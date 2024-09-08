import 'package:hive/hive.dart';
import 'package:smartconsultor/core/error/exceptions.dart';
import 'package:smartconsultor/core/hive/boxes/user_box.dart';
import 'package:smartconsultor/features/splash/data/models/splash_user_model.dart';



abstract class SplashLocalDataSource {
  Future<SplashUserModel?> getLoggedInUser();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  @override
  Future<SplashUserModel?> getLoggedInUser() async {
    try {
      await Hive.openBox(UserBox.USER_BOX);
      var userBox = Hive.box(UserBox.USER_BOX);
      if (userBox.isNotEmpty){
        UserBox user=userBox.getAt(0);
        DateTime now = DateTime.now();
        if (now.isAfter(user.refreshTokenExpiration)){
          userBox.deleteAt(0);
          return null;
        }
        userBox.close();
        return SplashUserModel(
          accessToken: user.accessToken,
          refreshToken: user.refreshToken,
          userId: user.userId,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          birthDate: user.birthDate,
          gender: user.gender,
          country: user.country,
          address: user.address,
          roles: user.roles,
          emailVerified: user.emailVerified,
          avatarUrl: user.avatarUrl,
          recentDevices: user.recentDevices,
          accessTokenExpiration: user.accessTokenExpiration,
          refreshTokenExpiration: user.refreshTokenExpiration,
          encryptionKey: user.encryptionKey,
        );
      }
      else {
        return null;
      }
    } catch (e) {
      throw CacheException(); // hoặc bất kỳ ngoại lệ tùy chỉnh nào khác
    }
  }
}
