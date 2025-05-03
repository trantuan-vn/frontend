// Import các package cần thiết cho xác thực, môi trường, logging và xử lý JWT
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get_it/get_it.dart';
import 'package:smartconsultor/core/env/environment_configuration.dart';
import 'package:smartconsultor/core/keycloak/jwt_helper.dart';
import 'package:smartconsultor/core/utils/crypto_utils.dart';

// Định nghĩa interface trừu tượng cho lớp đăng nhập trên mobile và desktop
abstract class LoginMobileDesktop {
  /// Gọi endpoint đăng nhập Keycloak và trả về một map chứa các token (access_token, id_token, refresh_token, expires_in).
  /// Ném [Exception] nếu xảy ra lỗi trong quá trình đăng nhập.
  Future<Map<String, dynamic>?> login();
}

// Lớp triển khai interface LoginMobileDesktop, xử lý đăng nhập qua Keycloak trên mobile và desktop
class LoginMobileDesktopImpl implements LoginMobileDesktop {
  // Constructor rỗng, không cần tham số khởi tạo
  LoginMobileDesktopImpl();

  @override
  Future<Map<String, dynamic>?> login() async {
    try {
      // Khởi tạo đối tượng FlutterAppAuth để thực hiện các yêu cầu xác thực OAuth2/OpenID Connect
      final FlutterAppAuth _appAuth = FlutterAppAuth();

      // Khởi tạo DotEnv để truy cập các biến môi trường từ file .env
      final config = GetIt.instance<EnvironmentConfiguration>();

      // Tạo nonce ngẫu nhiên để đảm bảo tính duy nhất của ID Token
      // Nonce giúp ngăn chặn tấn công replay bằng cách đảm bảo ID Token chỉ được sử dụng một lần
      final expectedNonce = CryptoUtils.generateBase64Key();

      // Gửi yêu cầu xác thực và trao đổi mã code để lấy token
      // AuthorizationTokenRequest chứa các thông tin cần thiết cho luồng Authorization Code
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          config.keycloakClientId, // Client ID của Keycloak, lấy từ file .env
          config
              .keycloakRedirectUri, // Redirect URI để nhận callback sau khi đăng nhập
          issuer: config
              .keycloakIssuer, // URL của Keycloak issuer (ví dụ: https://auth.smartconsultor.com/realms/master)
          nonce: expectedNonce, // Nonce để kiểm tra tính hợp lệ của ID Token
        ),
      );

      // Lấy ID Token từ kết quả trả về
      // Toán tử ! giả định idToken luôn tồn tại, có rủi ro crash nếu null
      final String? idToken = result.idToken;
      // Kiểm tra xem ID Token có tồn tại và không rỗng
      if (idToken == null || idToken.isEmpty) {
        throw Exception("idToken missing.");
      }
      // Verify Jwt Signature
      final isVerify =
          await JwtHelper.verifyJwtSignature(idToken, config.keycloakJwksUri);
      if (!isVerify) {
        throw Exception('Verify Jwt Signature: failed.');
      }
      // Xác thực ID Token bằng JwtHelper
      // Kiểm tra audience (aud) và thời gian hết hạn (exp) để đảm bảo token hợp lệ và được cấp cho đúng client
      JwtHelper.validateIdToken(idToken, config.keycloakClientId);

      // Lấy Access Token từ kết quả
      // Access Token dùng để gọi các API được bảo vệ
      final String? accessToken = result.accessToken;
      // Kiểm tra xem Access Token có tồn tại và không rỗng
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("accessToken missing.");
      }

      // Lấy Refresh Token từ kết quả
      // Refresh Token dùng để làm mới Access Token khi nó hết hạn
      final String? refreshToken = result.refreshToken;
      // Kiểm tra xem Refresh Token có tồn tại và không rỗng
      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception("refreshToken missing.");
      }

      // Kiểm tra thời gian hết hạn của Access Token
      // Nếu accessTokenExpirationDateTime là null, ném lỗi
      final expiresDateTime = result.accessTokenExpirationDateTime;
      if (expiresDateTime == null) {
        throw Exception("expiresIn missing.");
      }

      if (DateTime.now().toUtc().isAfter(expiresDateTime)) {
        throw Exception('ID token expired');
      }

      // Tạo map chứa các token và thông tin liên quan
      final tokens = {
        'access_token': accessToken, // Token dùng để gọi API
        'id_token': idToken, // Token chứa thông tin danh tính người dùng
        'refresh_token': refreshToken, // Token dùng để làm mới token
        'expiresDateTime':
            expiresDateTime, // Thời gian hết hạn của Access Token (tính bằng giây)
      };

      // Trả về map chứa các token
      return tokens;
    } catch (e) {
      rethrow; // Ném lại ngoại lệ để tầng trên (như LoginBloc) xử lý
    }
  }
}
