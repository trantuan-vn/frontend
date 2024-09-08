import 'package:hive/hive.dart';

part 'settings_box.g.dart';

@HiveType(typeId: 1)
class SettingsBox extends HiveObject {
  
  static const String SETTINGS_BOX = 'settings';

  @HiveField(0)
  late String language;

  @HiveField(1)
  late bool enableBiometricSecurity;

  @HiveField(2)
  late bool enableNotification;

  @HiveField(3)
  late bool darkMode;

  @HiveField(4)
  late int fontSize;

  @HiveField(5)
  late String themeColor;

  @HiveField(6)
  late bool useFingerprintUnlock;

  @HiveField(7)
  late bool enableAnalytics;

  @HiveField(8)
  late String defaultView;
}
