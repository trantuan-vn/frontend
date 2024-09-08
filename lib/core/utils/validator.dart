// file: utils/validator.dart
class Validator {
  static bool isEmail(String value) {
    // Sử dụng biểu thức chính quy để kiểm tra địa chỉ email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value);
  }

  static bool isStrongPassword(String value) {
    // Kiểm tra xem giá trị có đủ mạnh không
    // Yêu cầu ít nhất 8 ký tự, chứa ít nhất một chữ cái hoa, một chữ cái thường, và một số
    return value.length >= 8 && // đô dài phải lớn hơn 8
        value.contains(RegExp(r'[A-Z]')) && // ít nhất một chữ cái hoa
        value.contains(RegExp(r'[a-z]')) && // ít nhất một chữ cái thường
        value.contains(RegExp(r'[0-9]')) && // ít nhất một số
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) && // ít nhất 1 ký tự đặc biệt 
        true; // Thêm các yêu cầu khác nếu cần
  }
  static bool validatePhoneNumber(String phoneNumber) {
    // Sử dụng biểu thức chính quy để kiểm tra định dạng số điện thoại Việt Nam
    // Định dạng cơ bản: Bắt đầu bằng +84 hoặc 0, sau đó là 9 hoặc 10 chữ số
    RegExp regex = RegExp(r'^(0|\+84)\d{9,10}$');
    return regex.hasMatch(phoneNumber);
  }  
}
