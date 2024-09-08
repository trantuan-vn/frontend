import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;


  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'loginTitle': 'Login',
      'emailPhone': 'Email/Phone',
      'emailPhoneInvalid': 'Email/Phone is invalid',
      'strongPasswordInvalid': 'Weak password (password needs to be greater than 8 characters, a lowercase letter, a uppercase letter and a number)',
      'password': 'Password',
      'loginButtonTitle': 'Login',
    },
    'vn': {
      'loginTitle': 'Đăng nhập',
      'emailPhone': 'Email/SĐT',
      'emailPhoneInvalid': 'Email/SĐT không hợp lệ',
      'strongPasswordInvalid': 'Mật khẩu yếu (mật khẩu cần lớn hơn 8 ký tự, có chữ thường, chữ hoa và số)',
      'password': 'Mật khẩu',
      'loginButtonTitle': 'Đăng nhập',
    },
  };

  String getText(String value) => _localizedValues[locale.languageCode]?[value] ?? '';

  String get loginTitle => _localizedValues[locale.languageCode]?['loginTitle'] ?? '';
  String get emailPhoneInvalid => _localizedValues[locale.languageCode]?['emailPhoneInvalid'] ?? '';
  String get emailPhone => _localizedValues[locale.languageCode]?['emailPhone'] ?? '';
  String get strongPasswordInvalid => _localizedValues[locale.languageCode]?['strongPasswordInvalid'] ?? '';
  String get password => _localizedValues[locale.languageCode]?['password'] ?? '';
  String get loginButtonTitle => _localizedValues[locale.languageCode]?['loginButtonTitle'] ?? '';

}