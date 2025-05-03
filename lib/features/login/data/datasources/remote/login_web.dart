import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:smartconsultor/core/env/environment_configuration.dart';
import 'package:smartconsultor/core/keycloak/jwt_helper.dart';
import 'package:smartconsultor/core/utils/crypto_utils.dart';

// Định nghĩa interface cho lớp đăng nhập web
abstract class LoginWeb {
  /// Gọi endpoint đăng nhập Keycloak và trả về map chứa các token.
  /// Ném [Exception] nếu có lỗi.
  Future<Map<String, dynamic>?> login();
}

// Lớp triển khai interface LoginWeb, xử lý đăng nhập qua Keycloak trên web
class LoginWebImpl implements LoginWeb {
  LoginWebImpl();

  @override
  Future<Map<String, dynamic>?> login() async {
    try {
      // Khởi tạo DotEnv để truy cập biến môi trường từ file .env
      final config = GetIt.instance<EnvironmentConfiguration>();

      // Lấy redirect URI từ file .env, dùng để xử lý callback sau khi xác thực
      // Toán tử ! giả định KEYCLOAK_REDIRECT_URI_WEB luôn tồn tại
      final redirectUri = Uri.parse(config.keycloakRedirectUriWeb);

      // Tạo cặp code_verifier và code_challenge cho PKCE (Proof Key for Code Exchange)
      // code_verifier là chuỗi ngẫu nhiên, code_challenge là SHA-256 của code_verifier
      final mapCodeVerifierAndChallenge =
          CryptoUtils.generateCodeVerifierAndChallenge();

      // Tạo state ngẫu nhiên để ngăn chặn tấn công CSRF
      final expectedState = CryptoUtils.generateBase64Key();

      // Tạo nonce ngẫu nhiên để đảm bảo tính duy nhất của ID Token
      final expectedNonce = CryptoUtils.generateBase64Key();

      // Xây dựng URL xác thực Keycloak với các tham số query
      final authUri = Uri.parse(config.keycloakAuthorizationEndpoint).replace(
        queryParameters: {
          'client_id': config.keycloakClientId, // ID của client Keycloak
          'redirect_uri': redirectUri.toString(), // URI để nhận callback
          'response_type':
              'code', // Yêu cầu mã code cho luồng Authorization Code
          'scope': config
              .keycloakScopes, // Các scope yêu cầu (ví dụ: openid profile email)
          'code_challenge': mapCodeVerifierAndChallenge[
              'code_challenge']!, // Code challenge cho PKCE
          'code_challenge_method': 'S256', // Phương thức băm SHA-256
          'state': expectedState, // State để kiểm tra callback
          'nonce': expectedNonce, // Nonce để kiểm tra ID Token
        },
      );

      // Mở trình duyệt để người dùng đăng nhập qua Keycloak
      // FlutterWebAuth2.authenticate sẽ trả về URI callback sau khi đăng nhập thành công
      final result = await FlutterWebAuth2.authenticate(
        url: authUri.toString(),
        callbackUrlScheme:
            redirectUri.scheme, // Scheme của redirect URI (ví dụ: http)
      );

      // Parse URI callback từ Keycloak
      final callbackUri = Uri.parse(result);

      // Kiểm tra tính hợp lệ của callback URI
      // Đảm bảo scheme và host khớp với redirectUri để ngăn chặn tấn công giả mạo
      if (callbackUri.scheme != redirectUri.scheme ||
          callbackUri.host != redirectUri.host) {
        throw Exception("Invalid callback origin.");
      }

      // Lấy mã code từ query parameters của callback URI
      final code = callbackUri.queryParameters['code'];
      if (code == null || code.isEmpty) {
        throw Exception("Authorization code missing.");
      }

      // Kiểm tra state trả về có khớp với state gửi đi không
      // Điều này ngăn chặn tấn công CSRF
      final returnedState = callbackUri.queryParameters['state'];
      if (returnedState != expectedState) {
        throw Exception("Invalid state returned.");
      }

      // Gửi yêu cầu POST đến token endpoint của Keycloak để trao đổi mã code lấy token
      final response = await http.post(
        Uri.parse(config.keycloakTokenEndpoint), // URL của token endpoint
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type':
              'authorization_code', // Loại grant là authorization_code
          'client_id': config.keycloakClientId, // Client ID
          'redirect_uri': redirectUri.toString(), // Redirect URI
          'code': code, // Mã code nhận từ callback
          'code_verifier': mapCodeVerifierAndChallenge[
              'code_verifier']!, // Code verifier cho PKCE
        },
      );

      // Kiểm tra phản hồi từ token endpoint
      if (response.statusCode != 200) {
        throw Exception('Token request failed: ${response.body}');
      }

      // Parse phản hồi JSON từ token endpoint
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Kiểm tra nếu có lỗi trong phản hồi
      if (responseBody.containsKey('error')) {
        throw Exception(
            'Token failed: ${responseBody['error_description'] ?? responseBody['error']}');
      }

      // Lấy ID Token từ phản hồi
      final String? idToken = responseBody['id_token'];
      if (idToken == null || idToken.isEmpty) {
        throw Exception("idToken missing.");
      }
      // Verify Jwt Signature
      final isVerify =
          await JwtHelper.verifyJwtSignature(idToken, config.keycloakJwksUri);
      if (!isVerify) {
        throw Exception('Verify Jwt Signature: failed.');
      }
      // Kiểm tra nonce trong ID Token có khớp với nonce gửi đi không
      // Điều này đảm bảo ID Token không bị giả mạo
      final returnNonce = JwtHelper.getField(idToken, "nonce");
      if (returnNonce != expectedNonce) {
        throw Exception('Nonce mismatch.');
      }

      // Xác thực ID Token, kiểm tra audience (aud) và expiration (exp)
      JwtHelper.validateIdToken(idToken, config.keycloakClientId);

      // Lấy Access Token từ phản hồi
      final String? accessToken = responseBody['access_token'];
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("accessToken missing.");
      }

      // Lấy Refresh Token từ phản hồi
      final String? refreshToken = responseBody['refresh_token'];
      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception("refreshToken missing.");
      }

      // Lấy thời gian hết hạn của token
      final expiresDateTime = JwtHelper.getExpDate(idToken);

      // Tạo map chứa các token và thông tin liên quan
      final tokens = {
        'access_token': accessToken,
        'id_token': idToken,
        'refresh_token': refreshToken,
        'expiresDateTime': expiresDateTime,
      };

      // Trả về map chứa các token
      return tokens;
    } catch (e) {
      rethrow; // Ném lại ngoại lệ để tầng trên xử lý
    }
  }
}
