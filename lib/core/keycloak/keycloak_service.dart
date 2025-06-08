import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:smartconsultor/core/keycloak/jwt_helper.dart';
import '../utils/secure_token_storage.dart';

class KeycloakService {
  late final FlutterAppAuth _appAuth;

  late final String issuerUrl;
  late final String clientId;
  late final Uri redirectUri;
  late final Uri redirectUriWeb;

  late final String _tokenEndpoint;
  late final String _authorization_endpoint;
  late final String _userInfoEndpoint;
  late final String _logoutEndpoint;

  bool get isWeb => kIsWeb;
  Uri get _redirectUri => isWeb ? redirectUriWeb : redirectUri;

  late final SecureTokenStorage _tokenStorage;

  Map<String, dynamic>? _tokens;
  Timer? _tokenExpiryTimer;
  Completer<bool>? _refreshCompleter;

  KeycloakService({
    required String issuer,
    required String client,
    required String redirectScheme,
    required String redirectHostWeb,
  }) {
    issuerUrl = issuer;
    clientId = client;
    redirectUri = Uri.parse('$redirectScheme://callback');
    redirectUriWeb = Uri.parse('$redirectHostWeb/callback');
    init();
  }
  Future<void> init() async {
    _appAuth = FlutterAppAuth();
    _tokenStorage = await SecureTokenStorage.create();
    _tokenEndpoint = '$issuerUrl/protocol/openid-connect/token';
    _userInfoEndpoint = '$issuerUrl/protocol/openid-connect/userinfo';
    _authorization_endpoint = '$issuerUrl/protocol/openid-connect/auth';
    _logoutEndpoint = '$issuerUrl/protocol/openid-connect/logout';
    _restoreTokens();
  }

  // Token handling remains the same
  Future<void> _saveTokens(Map<String, dynamic>? tokens) async {
    if (tokens == null) return;
    try {
      await _tokenStorage.save(tokens);
      _tokens = tokens;
      _scheduleTokenRefresh();
    } catch (e) {
      rethrow;
    }
  }

  void _scheduleTokenRefresh() {
    _tokenExpiryTimer?.cancel();
    if (_tokens == null || _tokens!['expires_in'] == null) return;

    final expiresIn = int.tryParse(_tokens!['expires_in'].toString()) ?? 300;
    final refreshBefore = Duration(seconds: expiresIn - 30);

    _tokenExpiryTimer = Timer(refreshBefore, () async {
      try {
        final isRefreshed = await refreshToken();
        if (!isRefreshed) {
          await logout();
        }
      } catch (e) {
        await logout();
      }
    });
  }

  Future<void> _clearTokens() async {
    try {
      await _tokenStorage.clear();
      _tokens = null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _restoreTokens() async {
    try {
      _tokens = await _tokenStorage.read();
      if (_tokens == null || _tokens!['id_token'] == null) {
        return;
      }
      if (DateTime.now().isAfter(JwtHelper.getExpDate(_tokens?['id_token']))) {
        await _clearTokens();
      }
      _scheduleTokenRefresh();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login() async {
    try {
      //nonce
      Random rand = Random.secure();
      Uint8List bytes =
          Uint8List.fromList(List.generate(32, (_) => rand.nextInt(256)));
      String expectedNonce = base64UrlEncode(bytes).replaceAll('=', '');

      if (isWeb) {
        //state
        rand = Random.secure();
        bytes = Uint8List.fromList(List.generate(32, (_) => rand.nextInt(256)));
        String expectedState = base64UrlEncode(bytes).replaceAll('=', '');
        //_codeVerifier, _codeChallenge
        rand = Random.secure();
        bytes = Uint8List.fromList(List.generate(32, (_) => rand.nextInt(256)));
        String codeVerifier = base64UrlEncode(bytes).replaceAll('=', '');
        String codeChallenge =
            base64UrlEncode(sha256.convert(utf8.encode(codeVerifier)).bytes)
                .replaceAll('=', '');
        // build authUri
        final authUri = Uri.parse(_authorization_endpoint).replace(
          queryParameters: {
            'client_id': clientId,
            'redirect_uri': _redirectUri.toString(),
            'response_type': 'code',
            'scope': ['openid', 'profile', 'email'].join(' '),
            'code_challenge': codeChallenge,
            'code_challenge_method': 'S256',
            'state': expectedState,
            'nonce': expectedNonce,
          },
        );
        // Sử dụng flutter_web_auth_2 cho Web
        final result = await FlutterWebAuth2.authenticate(
          url: authUri.toString(),
          callbackUrlScheme: _redirectUri.toString().split(':')[0],
        );

        final callbackUri = Uri.parse(result);
        if (callbackUri.scheme != _redirectUri.scheme ||
            callbackUri.host != _redirectUri.host) {
          throw Exception("Invalid callback origin.");
        }
        final code = Uri.parse(result).queryParameters['code'];
        if (code == null || code.isEmpty) {
          throw Exception("Authorization code missing.");
        }
        final returnedState = callbackUri.queryParameters['state'];
        if (returnedState != expectedState) {
          throw Exception("Invalid state returned.");
        }

        final response = await http.post(
          Uri.parse(_tokenEndpoint),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'authorization_code',
            'client_id': clientId,
            'redirect_uri': _redirectUri.toString(),
            'code': code,
            'code_verifier': codeVerifier,
          },
        );

        if (response.statusCode != 200) {
          throw Exception('Token request failed: ${response.body}');
        }
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('error')) {
          throw Exception(
              'Token failed: ${responseBody['error_description'] ?? responseBody['error']}');
        }
        final String? idToken = responseBody['id_token'];
        if (idToken == null || idToken.isEmpty) {
          throw Exception("idToken missing.");
        }
        final returnNonce = JwtHelper.getField(idToken, "nonce");
        if (returnNonce != expectedNonce) {
          throw Exception('Nonce mismatch.');
        }

        _validateIdToken(idToken);

        final String? accessToken = responseBody['access_token'];
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception("accessToken missing.");
        }

        final String? refreshToken = responseBody['refresh_token'];
        if (refreshToken == null || refreshToken.isEmpty) {
          throw Exception("refreshToken missing.");
        }

        final int? expiresIn = responseBody['expires_in'];
        if (expiresIn == null || expiresIn.isNaN) {
          throw Exception("expiresIn missing.");
        }

        final tokens = {
          'access_token': accessToken,
          'id_token': idToken,
          'refresh_token': refreshToken,
          'expires_in': expiresIn,
        };

        await _saveTokens(tokens);
      } else {
        // Đối với Mobile, sử dụng AppAuth
        final result = await _appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            clientId,
            _redirectUri.toString(),
            issuer: issuerUrl,
            nonce: expectedNonce,
          ),
        );

        final String? idToken = result.idToken!;
        if (idToken == null || idToken.isEmpty) {
          throw Exception("idToken missing.");
        }

        _validateIdToken(idToken);

        final String? accessToken = result.accessToken!;
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception("accessToken missing.");
        }

        final String? refreshToken = result.refreshToken!;
        if (refreshToken == null || refreshToken.isEmpty) {
          throw Exception("refreshToken missing.");
        }
        final now = DateTime.now();
        int? expiresIn = result.accessTokenExpirationDateTime != null
            ? result.accessTokenExpirationDateTime!.difference(now).inSeconds
            : 300; // fallback nếu không có expiration
        if (expiresIn == null || expiresIn.isNaN) {
          throw Exception("expiresIn missing.");
        }

        final tokens = {
          'access_token': accessToken,
          'id_token': idToken,
          'refresh_token': refreshToken,
          'expires_in': expiresIn,
        };
        await _saveTokens(tokens);
      }
      await refreshToken();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_tokens == null) return;

    try {
      // Đối với Web, sử dụng FlutterWebAuth2 để logout mà không cần chuyển hướng trang
      if (isWeb) {
        final logoutUri = Uri.parse(_logoutEndpoint).replace(queryParameters: {
          'id_token_hint': _tokens!['id_token'],
          'post_logout_redirect_uri': _redirectUri.toString(),
        });
        await FlutterWebAuth2.authenticate(
          url: logoutUri.toString(),
          callbackUrlScheme: _redirectUri.scheme, // Extract scheme
        );
      } else {
        await _appAuth.endSession(
          EndSessionRequest(
            idTokenHint: _tokens?['id_token'],
            postLogoutRedirectUrl: _redirectUri.toString(),
            issuer: issuerUrl,
          ),
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      await _clearTokens();
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      if (_tokens == null || _tokens!['access_token'] == null) return null;
      final response = await http.get(
        Uri.parse(_userInfoEndpoint),
        headers: {'Authorization': 'Bearer ${_tokens!['access_token']}'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user info: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    // Nếu đang refresh thì các lời gọi sau sẽ đợi luôn Future của lần đầu
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }
    _refreshCompleter = Completer<bool>();

    try {
      if (_tokens == null || _tokens!['refresh_token'] == null) return false;
      late final String? accessToken;
      late final String? idToken;
      late final String? refreshToken;
      late final int? expiresIn;

      if (isWeb) {
        final response = await http.post(
          Uri.parse(_tokenEndpoint),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'refresh_token',
            'refresh_token': _tokens!['refresh_token'],
            'client_id': clientId,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          if (responseBody.containsKey('error')) {
            throw Exception(
                'Refresh token failed: ${responseBody['error_description'] ?? responseBody['error']}');
          }
          idToken = responseBody['id_token'];
          if (idToken == null || idToken.isEmpty) {
            throw Exception("idToken missing.");
          }

          _validateIdToken(idToken);

          accessToken = responseBody['access_token'];
          if (accessToken == null || accessToken.isEmpty) {
            throw Exception("accessToken missing.");
          }

          refreshToken = responseBody['refresh_token'];
          if (refreshToken == null || refreshToken.isEmpty) {
            throw Exception("refreshToken missing.");
          }

          expiresIn = responseBody['expires_in'];
          if (expiresIn == null || expiresIn.isNaN) {
            throw Exception("expiresIn missing.");
          }
        }
      } else {
        final TokenResponse result = await _appAuth.token(TokenRequest(
          clientId,
          _redirectUri.toString(),
          refreshToken: _tokens!['refresh_token'],
          issuer: issuerUrl,
        ));

        idToken = result.idToken!;
        if (idToken == null || idToken.isEmpty) {
          throw Exception("idToken missing.");
        }

        _validateIdToken(idToken);

        accessToken = result.accessToken!;
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception("accessToken missing.");
        }

        refreshToken = result.refreshToken!;
        if (refreshToken == null || refreshToken.isEmpty) {
          throw Exception("refreshToken missing.");
        }
        final now = DateTime.now();
        expiresIn = result.accessTokenExpirationDateTime != null
            ? result.accessTokenExpirationDateTime!.difference(now).inSeconds
            : 300; // fallback nếu không có expiration
        if (expiresIn == null || expiresIn.isNaN) {
          throw Exception("expiresIn missing.");
        }
      }

      if (accessToken != null &&
          idToken != null &&
          refreshToken != null &&
          expiresIn != null) {
        final refreshedTokens = {
          'access_token': accessToken,
          'id_token': idToken,
          'refresh_token': refreshToken,
          'expires_in': expiresIn,
        };
        await _saveTokens(refreshedTokens);
        _refreshCompleter!.complete(true);
      } else {
        _refreshCompleter!.complete(false);
      }
    } catch (e) {
      _refreshCompleter!.completeError(e);
    } finally {
      // Reset để lần sau có thể gọi lại
      final completedFuture = _refreshCompleter!.future;
      _refreshCompleter = null;
      return completedFuture;
    }
  }

  bool get isLoggedIn => _tokens != null && accessToken != null;
  String? get accessToken => _tokens?['access_token'];
  String? get idToken => _tokens?['id_token'];
  void _dispose() {
    _tokenExpiryTimer?.cancel();
    _tokenExpiryTimer = null;
  }

  Future<void> close() async {
    _dispose(); // Cancel timer
    await _clearTokens(); // Nếu muốn clear luôn storage
  }

  void _validateIdToken(String idToken) {
    final aud = JwtHelper.getField(idToken, 'aud');
    if (aud is String && aud != clientId) {
      throw Exception("Invalid audience.");
    }
    if (aud is List && !aud.contains(clientId)) {
      throw Exception("Invalid audience.");
    }
    final exp = JwtHelper.getExpDate(idToken);
    if (exp == null || DateTime.now().isAfter(exp)) {
      throw Exception("ID token expired.");
    }
  }
}
