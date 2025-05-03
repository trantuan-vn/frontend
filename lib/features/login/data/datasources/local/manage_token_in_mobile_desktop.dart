import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartconsultor/core/log/log_manager.dart';

abstract class ManageTokenInMobileDesktop {
  Future<void> save(String key, Map<String, dynamic> tokens);
  Future<Map<String, dynamic>?> read(String key);
  Future<void> clear(String key);
}

class ManageTokenInMobileDesktopImpl implements ManageTokenInMobileDesktop {
  final FlutterSecureStorage _secureStorage;
  // Constructor rỗng, không cần tham số khởi tạo
  ManageTokenInMobileDesktopImpl({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> save(String key, Map<String, dynamic> tokens) async {
    try {
      final json = jsonEncode(tokens);
      await _secureStorage.write(key: key, value: json);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> read(String key) async {
    try {
      final json = await _secureStorage.read(key: key);
      if (json == null) {
        return null;
      }
      return jsonDecode(json);
    } catch (e) {
      await clear(key);
      rethrow;
    }
  }

  @override
  Future<void> clear(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      rethrow;
    }
  }
}
