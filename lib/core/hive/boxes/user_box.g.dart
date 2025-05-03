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
      ..roles = (fields[5] as List).cast<String>()
      ..emailVerified = fields[6] as bool
      ..accessTokenExpiration = fields[7] as DateTime
      ..expiresIn = fields[8] as int
      ..refreshExpiresIn = fields[9] as int
      ..tokenType = fields[10] as String
      ..notBeforePolicy = fields[11] as int
      ..sessionState = fields[12] as String
      ..scope = fields[13] as String;
  }

  @override
  void write(BinaryWriter writer, UserBox obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.roles)
      ..writeByte(6)
      ..write(obj.emailVerified)
      ..writeByte(7)
      ..write(obj.accessTokenExpiration)
      ..writeByte(8)
      ..write(obj.expiresIn)
      ..writeByte(9)
      ..write(obj.refreshExpiresIn)
      ..writeByte(10)
      ..write(obj.tokenType)
      ..writeByte(11)
      ..write(obj.notBeforePolicy)
      ..writeByte(12)
      ..write(obj.sessionState)
      ..writeByte(13)
      ..write(obj.scope);
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
