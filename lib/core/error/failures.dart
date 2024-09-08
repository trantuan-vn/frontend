class Failure {
  final String message;

  Failure(this.message);
}

class InvalidCredentials extends Failure {
  InvalidCredentials() : super("Invalid username or password");
}

class NetworkError extends Failure {
  NetworkError() : super("Network error. Please check your internet connection.");
}

// Thêm các lớp lỗi khác nếu cần thiết
class ServerFailure extends Failure {
  ServerFailure(): super("Server error");
}

class CacheFailure extends Failure {
  CacheFailure(): super("Cache error");
}


