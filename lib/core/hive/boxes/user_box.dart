import 'package:hive/hive.dart';

part 'user_box.g.dart'; // Đây là file tự động được tạo bởi Hive

@HiveType(typeId: 2)
class UserBox extends HiveObject {
  static const String USER_BOX = 'users';

  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String accessToken;

  @HiveField(2)
  late String refreshToken;

  @HiveField(3)
  late String fullName;

  @HiveField(4)
  late String email;

  @HiveField(5)
  late String phoneNumber;

  @HiveField(6)
  late DateTime birthDate;

  @HiveField(7)
  late String gender;

  @HiveField(8)
  late String country;

  @HiveField(9)
  late String address;

  @HiveField(10)
  late List<String> roles;

  @HiveField(11)
  late bool emailVerified;

  @HiveField(12)
  late String avatarUrl;

  @HiveField(13)
  late List<String> recentDevices;

  @HiveField(14)
  late DateTime accessTokenExpiration;

  @HiveField(15)
  late DateTime refreshTokenExpiration;

  @HiveField(16)
  late String encryptionKey;
}
