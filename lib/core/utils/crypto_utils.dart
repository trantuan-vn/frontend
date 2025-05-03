import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class CryptoUtils {
  /// Generates a secure random parameter for OAuth2 authentication.
  static String generateBase64Key() {
    final rand = Random.secure();
    final bytes =
        Uint8List.fromList(List.generate(32, (_) => rand.nextInt(256)));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  /// Generates a code verifier and code challenge for PKCE (Proof Key for Code Exchange).
  /// Returns a map containing the code verifier and its SHA-256 base64 URL-safe challenge.
  static Map<String, String> generateCodeVerifierAndChallenge() {
    final codeVerifier = generateBase64Key();
    final codeChallenge = base64UrlEncode(
      sha256.convert(utf8.encode(codeVerifier)).bytes,
    ).replaceAll('=', '');
    return {
      'code_verifier': codeVerifier,
      'code_challenge': codeChallenge,
    };
  }
}
