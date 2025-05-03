import 'package:hive/hive.dart';

part 'user_box.g.dart'; // file sẽ được tạo bằng lệnh build_runner

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
  late List<String> roles;

  @HiveField(6)
  late bool emailVerified;

  @HiveField(7)
  late DateTime accessTokenExpiration;

  @HiveField(8)
  late int expiresIn;

  @HiveField(9)
  late int refreshExpiresIn;

  @HiveField(10)
  late String tokenType;

  @HiveField(11)
  late int notBeforePolicy;

  @HiveField(12)
  late String sessionState;

  @HiveField(13)
  late String scope;
}
