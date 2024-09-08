import 'package:smartconsultor/features/login/domain/entities/user.dart';

class SplashUser extends User {
  SplashUser(
      {required super.accessToken,
      required super.refreshToken,
      required super.userId,
      required super.fullName,
      required super.email,
      required super.phoneNumber,
      required super.birthDate,
      required super.gender,
      required super.country,
      required super.address,
      required super.roles,
      required super.emailVerified,
      required super.avatarUrl,
      required super.recentDevices,
      required super.accessTokenExpiration,
      required super.refreshTokenExpiration,
      required super.encryptionKey});
}