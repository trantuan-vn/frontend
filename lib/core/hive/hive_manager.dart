// hive_manager.dart
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:smartconsultor/core/hive/boxes/settings_box.dart';
import 'package:smartconsultor/core/hive/boxes/user_box.dart';

class HiveManager {
  static Future<void> initialize() async {
    //final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    //Hive.initFlutter(appDocumentDirectory.path);    
    Hive.initFlutter();    
  }
  static Future<void> registerAdapter() async {
    // Register SettingsBoxAdapter
    Hive.registerAdapter(SettingsBoxAdapter()); 
    // Register UserBoxAdapter
    Hive.registerAdapter(UserBoxAdapter()); 
  }
  

}
