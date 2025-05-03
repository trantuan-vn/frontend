import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:universal_html/html.dart' as html;

/// Quản lý token trong RAM bảo mật cao (Web-only)
class InMemorySecureTokenStorageV4 {
  static final InMemorySecureTokenStorageV4 _instance =
      InMemorySecureTokenStorageV4._internal();

  factory InMemorySecureTokenStorageV4() => _instance;

  InMemorySecureTokenStorageV4._internal() {
    _initSecurityHooks();
    final fingerprint = _getBrowserFingerprint();
    _salt = _generateRandomSalt();
    _sessionId = _generateSessionId();
    final aesKey = _deriveAESKey(fingerprint, _salt);
    _encrypter =
        encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.cbc));
  }

  late final encrypt.Encrypter _encrypter;
  late final String _salt;
  late final String _sessionId;

  encrypt.IV? _iv;
  String? _encryptedData;

  Timer? _idleTimer;
  DateTime? _lastVisibleTimestamp;

  static const Duration _idleTimeout = Duration(minutes: 15);
  static const Duration _hiddenTimeout = Duration(minutes: 10);

  bool get isWeb => kIsWeb;

  // --- Fingerprint, Key derivation ---
  String _getBrowserFingerprint() {
    final userAgent = html.window.navigator.userAgent.trim().toLowerCase();
    final platform = html.window.navigator.platform?.trim().toLowerCase() ?? '';
    return '$userAgent::$platform';
  }

  String _generateRandomSalt() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _generateSessionId() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    return sha256.convert(bytes).toString().substring(0, 16);
  }

  encrypt.Key _deriveAESKey(String fingerprint, String salt) {
    final full = '$fingerprint::$salt';
    final hash = sha256.convert(utf8.encode(full)).toString();
    return encrypt.Key.fromUtf8(hash.substring(0, 32));
  }

  // --- Save + Read ---
  Future<void> save(Map<String, dynamic> tokens) async {
    final json = jsonEncode({...tokens, '__session_id': _sessionId});
    _iv = encrypt.IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(json, iv: _iv!);
    _encryptedData = encrypted.base64;

    _resetIdleTimer();
  }

  Future<Map<String, dynamic>?> _decryptToken() async {
    if (_encryptedData == null || _iv == null) return null;

    try {
      final decrypted = _encrypter.decrypt64(_encryptedData!, iv: _iv!);
      final data = jsonDecode(decrypted);

      if (data['__session_id'] != _sessionId) {
        await clear();
        return null;
      }

      return Map<String, dynamic>.from(data)..remove('__session_id');
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<String?> getAccessToken() async {
    final data = await _decryptToken();
    _resetIdleTimer();
    return data?['access_token'];
  }

  Future<bool> isTokenExpired() async {
    final data = await _decryptToken();
    _resetIdleTimer();

    try {
      final exp = data?['expires_at'];
      if (exp == null) return true;

      return DateTime.now()
          .isAfter(DateTime.parse(exp).subtract(Duration(seconds: 30)));
    } catch (_) {
      return true;
    }
  }

  // --- Clear ---
  Future<void> clear() async {
    if (_encryptedData != null) {
      _encryptedData = '0' * _encryptedData!.length;
    }
    _encryptedData = null;
    _iv = null;
    _idleTimer?.cancel();
  }

  bool get hasToken => _encryptedData != null;

  // --- Auto Clear Hooks ---
  void _initSecurityHooks() {
    // Hook vào activity: click, move, keypress
    html.window.onMouseMove.listen((_) => _resetIdleTimer());
    html.window.onClick.listen((_) => _resetIdleTimer());
    html.window.onKeyPress.listen((_) => _resetIdleTimer());

    // Hook vào tab visibility
    html.document.onVisibilityChange.listen((_) {
      if (html.document.hidden!) {
        _lastVisibleTimestamp = DateTime.now();
      } else {
        final now = DateTime.now();
        final hiddenDuration = now.difference(_lastVisibleTimestamp ?? now);
        if (hiddenDuration > _hiddenTimeout) {
          clear(); // Tab background quá lâu
        }
        _resetIdleTimer();
      }
    });
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleTimeout, () {
      clear(); // Không hoạt động quá lâu → clear
    });
  }
}
