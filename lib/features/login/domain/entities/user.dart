import 'package:equatable/equatable.dart';

class User extends Equatable{
  late String accessToken;
  late String refreshToken;
  late String userId;
  late String fullName;
  late String email;
  late String phoneNumber;
  late DateTime birthDate;
  late String gender;
  late String country;
  late String address;
  late List<String> roles;
  late bool emailVerified;
  late String avatarUrl;
  late List<String> recentDevices; // List of recently used devices
  late DateTime accessTokenExpiration; // Access token expiration time
  late DateTime refreshTokenExpiration; // Refresh token expiration time
  late String encryptionKey;

  User({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    required this.country,
    required this.address,
    required this.roles,
    required this.emailVerified,
    required this.avatarUrl,
    required this.recentDevices,
    required this.accessTokenExpiration,
    required this.refreshTokenExpiration,    
    required this.encryptionKey,    
  });

  @override
  List<Object> get props => [
    accessToken,
    refreshToken,
    userId,
    fullName,
    email,
    phoneNumber,
    birthDate,
    gender,
    country,
    address,
    roles,
    emailVerified,
    avatarUrl,
    recentDevices,
    accessTokenExpiration,
    refreshTokenExpiration,    
    encryptionKey,   
  ];
}
