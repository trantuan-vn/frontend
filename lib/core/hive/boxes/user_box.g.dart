// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserBoxAdapter extends TypeAdapter<UserBox> {
  @override
  final int typeId = 2;

  @override
  UserBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBox()
      ..userId = fields[0] as String
      ..accessToken = fields[1] as String
      ..refreshToken = fields[2] as String
      ..fullName = fields[3] as String
      ..email = fields[4] as String
      ..phoneNumber = fields[5] as String
      ..birthDate = fields[6] as DateTime
      ..gender = fields[7] as String
      ..country = fields[8] as String
      ..address = fields[9] as String
      ..roles = (fields[10] as List).cast<String>()
      ..emailVerified = fields[11] as bool
      ..avatarUrl = fields[12] as String
      ..recentDevices = (fields[13] as List).cast<String>()
      ..accessTokenExpiration = fields[14] as DateTime
      ..refreshTokenExpiration = fields[15] as DateTime
      ..encryptionKey = fields[16] as String;
  }

  @override
  void write(BinaryWriter writer, UserBox obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.refreshToken)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.birthDate)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.roles)
      ..writeByte(11)
      ..write(obj.emailVerified)
      ..writeByte(12)
      ..write(obj.avatarUrl)
      ..writeByte(13)
      ..write(obj.recentDevices)
      ..writeByte(14)
      ..write(obj.accessTokenExpiration)
      ..writeByte(15)
      ..write(obj.refreshTokenExpiration)
      ..writeByte(16)
      ..write(obj.encryptionKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
