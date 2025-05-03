import 'dart:async';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get_it/get_it.dart';
import 'package:smartconsultor/core/env/environment_configuration.dart';
import 'package:smartconsultor/core/keycloak/jwt_helper.dart';

abstract class RefreshTokenMobileDesktop {
  Future<Map<String, dynamic>?> refreshToken(String refreshToken);
}

class RefreshTokenMobileDesktopImpl implements RefreshTokenMobileDesktop {
  late final FlutterAppAuth _appAuth;

  RefreshTokenMobileDesktopImpl();

  @override
  Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    final config = GetIt.instance<EnvironmentConfiguration>();
    Map<String, dynamic>? tokens;

    try {
      _appAuth = FlutterAppAuth();

      final TokenResponse? result = await _appAuth.token(TokenRequest(
        config.keycloakClientId,
        config.keycloakRedirectUri,
        refreshToken: refreshToken,
        discoveryUrl: config.keycloakIssuer,
        scopes: config.keycloakScopes
            .split(' '), // Ex: ['openid', 'profile', 'email']
      ));

      if (result == null) {
        throw Exception('Token refresh failed: no response.');
      }

      final idToken = result.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw Exception('idToken missing.');
      }

      final isVerified =
          await JwtHelper.verifyJwtSignature(idToken, config.keycloakJwksUri);
      if (!isVerified) {
        throw Exception('Verify Jwt Signature: failed.');
      }

      JwtHelper.validateIdToken(idToken, config.keycloakClientId);

      final accessToken = result.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('accessToken missing.');
      }

      final newRefreshToken = result.refreshToken;
      if (newRefreshToken == null || newRefreshToken.isEmpty) {
        throw Exception('refreshToken missing.');
      }

      final expiresDateTime = JwtHelper.getExpDate(idToken);

      tokens = {
        'access_token': accessToken,
        'id_token': idToken,
        'refresh_token': newRefreshToken,
        'expiresDateTime': expiresDateTime,
      };
    } catch (e) {
      rethrow;
    }

    return tokens;
  }
}
