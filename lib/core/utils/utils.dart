import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart'; 

Future<bool> openUrl(String url, {bool newWindow = false}) async {
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    return await launch(
      url,
    );
  } else {
    debugPrint("Could not launch $url");
    return false;
  }
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  final storage = FlutterSecureStorage();

  // Lưu trữ thông tin khi đăng nhập thành công cho iOS và Android
  await storage.write(key: 'access_token', value: accessToken);
  await storage.write(key: 'refresh_token', value: refreshToken);

  // Lưu trữ thông tin khi đăng nhập thành công cho Web
  //if (html.window != null) {
    final expires = DateTime.now().add(Duration(days: 30));
    final cookie = 'access_token=$accessToken; expires=$expires; path=/; HttpOnly';
    //html.document.cookie = cookie;
    //html.window.localStorage['refresh_token'] = refreshToken;
  //}

  // Lưu trữ thông tin khi đăng nhập thành công cho Windows và macOS
  if (Platform.isWindows || Platform.isMacOS) {
    await saveTokensForWindowsAndMacOS(accessToken, refreshToken);
  }
}

Future<void> saveTokensForWindowsAndMacOS(String accessToken, String refreshToken) async {
  // Thực hiện lưu trữ trên hệ điều hành Windows và macOS ở đây
  // Ví dụ: sử dụng UserDefaults trên macOS và Registry trên Windows

  // Đây là một ví dụ giả định, bạn cần điều chỉnh code theo API của hệ điều hành cụ thể.
  if (Platform.isMacOS) {
    // Sử dụng UserDefaults trên macOS
    // Ví dụ:
    //UserDefaults().setString('access_token', accessToken);
    //UserDefaults().setString('refresh_token', refreshToken);
  } else if (Platform.isWindows) {
    // Sử dụng Registry trên Windows
    // Ví dụ:
   // Registry().setString('HKEY_CURRENT_USER\\Software\\YourAppName', 'access_token', accessToken);
    //Registry().setString('HKEY_CURRENT_USER\\Software\\YourAppName', 'refresh_token', refreshToken);
  }
}
