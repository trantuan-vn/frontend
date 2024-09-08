

import 'package:smartconsultor/features/login/domain/entities/user.dart';

class UserModel extends User {
  static const String USER_BOX = 'user';
  UserModel({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String fullName,
    required String email,
    required String phoneNumber,
    required DateTime birthDate,
    required String gender,
    required String country,
    required String address,
    required List<String> roles,
    required bool emailVerified,
    required String avatarUrl,
    required List<String> recentDevices,
    required DateTime accessTokenExpiration,
    required DateTime refreshTokenExpiration,
    required String encryptionKey,
  }) : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: userId,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          birthDate: birthDate,
          gender: gender,
          country: country,
          address: address,
          roles: roles,
          emailVerified: emailVerified,
          avatarUrl: avatarUrl,
          recentDevices: recentDevices,
          accessTokenExpiration: accessTokenExpiration,
          refreshTokenExpiration: refreshTokenExpiration,
          encryptionKey: encryptionKey,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      birthDate: DateTime.parse(json['birth_date'] ?? ''),
      gender: json['gender'] ?? '',
      country: json['country'] ?? '',
      address: json['address'] ?? '',
      roles: (json['roles'] ?? '').split(','),
      emailVerified: json['email_verified'] ?? false,
      avatarUrl: json['avatar_url'] ?? '',
      recentDevices: (json['recent_devices'] ?? '').split(','),
      accessTokenExpiration: DateTime.parse(json['access_token_expiration'] ?? ''),
      refreshTokenExpiration: DateTime.parse(json['refresh_token_expiration'] ?? ''),
      encryptionKey: json['encryption_key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'country': country,
      'address': address,
      'roles': roles,
      'email_verified': emailVerified,
      'avatar_url': avatarUrl,
      'recent_devices': recentDevices,
      'access_token_expiration': accessTokenExpiration.toIso8601String(),
      'refresh_token_expiration': refreshTokenExpiration.toIso8601String(),
      'encryption_key': encryptionKey,
    };
  }
}
