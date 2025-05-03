import 'dart:async';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get_it/get_it.dart';
import 'package:smartconsultor/core/env/environment_configuration.dart';
import 'package:smartconsultor/core/keycloak/jwt_helper.dart';
import 'package:smartconsultor/core/log/log_manager.dart';

/// Abstract class định nghĩa interface cho việc làm mới token.
abstract class RefreshTokenWeb {
  /// Gọi endpoint Keycloak để làm mới token và trả về map chứa các token.
  /// Ném [Exception] nếu có lỗi xảy ra.
  Future<Map<String, dynamic>?> refreshToken(String refreshToken);
}

/// Implementation của [RefreshToken] sử dụng flutter_web_auth_2 để làm mới token.
class RefreshTokenWebImpl implements RefreshTokenWeb {
  RefreshTokenWebImpl();

  @override
  Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    final config = GetIt.instance<EnvironmentConfiguration>();
    Map<String, dynamic>? tokens;

    try {
      // Tạo URL xác thực với các query parameters
      final authUrl = Uri.parse(config.keycloakTokenEndpoint).replace(
        queryParameters: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': config.keycloakClientId,
          'scope': config.keycloakScopes,
        },
      );

      // Cấu hình redirect URI (phải được đăng ký trong Keycloak)
      Uri redirectUri = Uri.parse(
          config.keycloakRedirectUriWeb); // Thay đổi theo cấu hình thực tế

      // Gọi flutter_web_auth_2 để thực hiện xác thực
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: redirectUri.scheme, // Phải khớp với redirectUri
      );

      // Phân tích callback URL để lấy token
      final callbackUri = Uri.parse(result);
      final responseBody = <String, dynamic>{};

      // Trích xuất các token từ query parameters
      callbackUri.queryParameters.forEach((key, value) {
        responseBody[key] = value;
      });

      // Trích xuất token từ fragment nếu có (Keycloak có thể trả về trong fragment)
      if (callbackUri.fragment.isNotEmpty) {
        final fragmentParams = Uri.splitQueryString(callbackUri.fragment);
        responseBody.addAll(fragmentParams);
      }

      // Kiểm tra lỗi trong phản hồi
      if (responseBody.containsKey('error')) {
        throw Exception(
          'Refresh token failed: ${responseBody['error_description'] ?? responseBody['error']}',
        );
      }

      // Kiểm tra id_token
      final idToken = responseBody['id_token'];
      if (idToken == null || idToken.isEmpty) {
        throw Exception('idToken missing.');
      }

      // Xác minh chữ ký JWT
      final isVerify =
          await JwtHelper.verifyJwtSignature(idToken, config.keycloakJwksUri);
      if (!isVerify) {
        throw Exception('Verify Jwt Signature: failed.');
      }

      // Xác thực id_token
      JwtHelper.validateIdToken(idToken, config.keycloakClientId);

      // Kiểm tra access_token
      final accessToken = responseBody['access_token'];
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('accessToken missing.');
      }

      // Kiểm tra refresh_token mới
      final newRefreshToken = responseBody['refresh_token'];
      if (newRefreshToken == null || newRefreshToken.isEmpty) {
        throw Exception('refreshToken missing.');
      }

      // Lấy thời gian hết hạn của token
      final expiresDateTime = JwtHelper.getExpDate(idToken);

      // Tạo map chứa các token
      tokens = {
        'access_token': accessToken, // Token dùng để gọi API
        'id_token': idToken, // Token chứa thông tin danh tính người dùng
        'refresh_token': newRefreshToken, // Token dùng để làm mới token
        'expiresDateTime': expiresDateTime, // Thời gian hết hạn của token
      };
    } catch (e) {
      rethrow; // Ném lại lỗi để người gọi xử lý
    }

    return tokens;
  }
}
