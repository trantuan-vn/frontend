// hive_manager.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:smartconsultor/core/hive/boxes/settings_box.dart';
import 'package:smartconsultor/core/hive/boxes/user_box.dart';

class HiveManager {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Nếu chạy trên Web, chỉ cần sử dụng Hive.initFlutter mà không cần đường dẫn
      await Hive.initFlutter();
    } else {
      // Đường dẫn trên iOS/Android
      final appDocumentDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
    }
  }

  static Future<void> registerAdapter() async {
    // Register SettingsBoxAdapter
    Hive.registerAdapter(SettingsBoxAdapter());
    // Register UserBoxAdapter
    Hive.registerAdapter(UserBoxAdapter());
  }
}
