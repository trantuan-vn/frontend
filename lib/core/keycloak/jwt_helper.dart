import 'dart:convert';
import 'package:jose/jose.dart';
import 'package:http/http.dart' as http;

class JwtHelper {
  /// Lấy scope hoặc roles nếu có
  static dynamic getField(String? jwt, String key) {
    final payload = _decode(jwt);
    return payload?[key];
  }

  static DateTime getExpDate(String? jwt) {
    final payload = _decode(jwt);
    final exp = payload?['exp'];
    if (exp == null || exp is! int) {
      throw Exception('Invalid or missing exp claim in ID token');
    }
    final expDate =
        DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    if (DateTime.now().toUtc().isAfter(expDate)) {
      throw Exception('ID token expired');
    }
    return expDate;
  }

  static void validateIdToken(String idToken, String clientId) {
    final payload = _decode(idToken);

    // Validate audience (aud)
    final aud = payload?['aud'];
    if (aud is String && aud != clientId) {
      throw Exception('Invalid audience: expected $clientId, got $aud');
    }
    if (aud is List && !aud.contains(clientId)) {
      throw Exception('Invalid audience: $clientId not in $aud');
    }
  }

  /// Giải mã payload từ JWT (access_token hoặc id_token)
  static Map<String, dynamic>? _decode(String? jwt) {
    if (jwt == null || jwt.isEmpty) return null;

    final parts = jwt.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded);
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> verifyJwtSignature(String token, String jwks_uri) async {
    try {
      final jwksResponse = await http.get(Uri.parse(jwks_uri));
      final jwks = JsonWebKeyStore()
        ..addKeySet(JsonWebKeySet.fromJson(jsonDecode(jwksResponse.body)));
      final jwt = JsonWebToken.unverified(token);
      return jwt.verify(jwks);
    } catch (e) {
      rethrow;
    }
  }
}
