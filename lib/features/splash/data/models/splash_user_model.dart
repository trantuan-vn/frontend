

import 'package:smartconsultor/features/splash/domain/entities/splash_user.dart';

class SplashUserModel extends SplashUser {
  SplashUserModel(
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