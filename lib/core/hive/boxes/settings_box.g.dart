// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsBoxAdapter extends TypeAdapter<SettingsBox> {
  @override
  final int typeId = 1;

  @override
  SettingsBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsBox()
      ..language = fields[0] as String
      ..enableBiometricSecurity = fields[1] as bool
      ..enableNotification = fields[2] as bool
      ..darkMode = fields[3] as bool
      ..fontSize = fields[4] as int
      ..themeColor = fields[5] as String
      ..useFingerprintUnlock = fields[6] as bool
      ..enableAnalytics = fields[7] as bool
      ..defaultView = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, SettingsBox obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.enableBiometricSecurity)
      ..writeByte(2)
      ..write(obj.enableNotification)
      ..writeByte(3)
      ..write(obj.darkMode)
      ..writeByte(4)
      ..write(obj.fontSize)
      ..writeByte(5)
      ..write(obj.themeColor)
      ..writeByte(6)
      ..write(obj.useFingerprintUnlock)
      ..writeByte(7)
      ..write(obj.enableAnalytics)
      ..writeByte(8)
      ..write(obj.defaultView);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
