import 'package:hive/hive.dart';
import 'package:smartconsultor/core/error/exceptions.dart';
import 'package:smartconsultor/core/hive/boxes/user_box.dart';
import 'package:smartconsultor/features/login/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveLoggedInUser(UserModel user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<void> saveLoggedInUser(UserModel user) async {
    try {
      await Hive.openBox(UserBox.USER_BOX);
      var userBox = Hive.box(UserBox.USER_BOX);
      var _user = UserBox()
      ..userId = user.userId
      ..accessToken = user.accessToken
      ..refreshToken = user.refreshToken
      ..fullName = user.fullName
      ..email = user.email
      ..phoneNumber = user.phoneNumber
      ..birthDate = user.birthDate
      ..gender = user.gender
      ..country = user.country
      ..address = user.address
      ..roles = user.roles
      ..emailVerified = user.emailVerified
      ..avatarUrl = user.avatarUrl
      ..recentDevices = user.recentDevices
      ..accessTokenExpiration = user.accessTokenExpiration
      ..refreshTokenExpiration = user.refreshTokenExpiration
      ..encryptionKey = user.encryptionKey;
      userBox.add(_user);
      userBox.close();
    } catch (e) {
      throw CacheException(); // hoặc bất kỳ ngoại lệ tùy chỉnh nào khác
    }
  }
}
