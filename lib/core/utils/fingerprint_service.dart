import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:universal_io/io.dart' as universal;

/// A service to generate fingerprint and AES key from device info
class FingerprintService {
  static const String _salt = 'secure_salt';

  static Future<String> getFingerprint() async {
    try {
      if (kIsWeb) {
        // ignore: avoid_web_libraries_in_flutter
        final userAgent = html.window.navigator.userAgent.trim().toLowerCase();
        // ignore: avoid_web_libraries_in_flutter
        final platform =
            html.window.navigator.platform?.trim().toLowerCase() ?? '';
        return 'web::$userAgent::$platform';
      }

      final deviceInfo = DeviceInfoPlugin();

      if (universal.Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        return 'android::${info.model ?? ''}::${info.id ?? ''}';
      }

      if (universal.Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        return 'ios::${info.utsname.machine ?? ''}::${info.identifierForVendor ?? ''}';
      }

      if (universal.Platform.isMacOS) {
        final info = await deviceInfo.macOsInfo;
        return 'macos::${info.model ?? ''}::${info.kernelVersion ?? ''}';
      }

      if (universal.Platform.isWindows) {
        final info = await deviceInfo.windowsInfo;
        return 'windows::${info.computerName ?? ''}::${info.numberOfCores}';
      }

      if (universal.Platform.isLinux) {
        final info = await deviceInfo.linuxInfo;
        return 'linux::${info.prettyName ?? ''}::${info.version ?? ''}';
      }

      return 'unknown::unknown';
    } catch (e) {
      rethrow;
    }
  }

  static Future<encrypt.Key> generateAESKey() async {
    try {
      final fingerprint = await getFingerprint();
      final full = '$fingerprint::$_salt';
      final hash = sha256.convert(utf8.encode(full)).toString();
      return encrypt.Key.fromUtf8(hash.substring(0, 32)); // AES-256
    } catch (e) {
      rethrow;
    }
  }
}
