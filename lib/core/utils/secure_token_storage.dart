import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartconsultor/core/utils/fingerprint_service.dart';

class SecureTokenStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final String _key;

  SecureTokenStorage._(this._key);

  static Future<SecureTokenStorage> create() async {
    try {
      final key = await FingerprintService.getFingerprint();
      return SecureTokenStorage._(key);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> save(Map<String, dynamic> tokens) async {
    try {
      final json = jsonEncode(tokens);
      await _secureStorage.write(key: _key, value: json);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> read() async {
    try {
      final json = await _secureStorage.read(key: _key);
      if (json == null) return null;
      return jsonDecode(json);
    } catch (e) {
      await clear();
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await _secureStorage.delete(key: _key);
    } catch (e) {
      rethrow;
    }
  }
}
