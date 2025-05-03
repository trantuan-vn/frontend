import 'package:equatable/equatable.dart';

/// Base class for all failures
class Failure extends Equatable {
  final String message;
  final dynamic exception;
  final StackTrace? stackTrace;

  const Failure(
    this.message, [
    this.exception,
    this.stackTrace,
  ]);

  /// For readable logging
  @override
  String toString() {
    final detail = exception != null ? ' - ${exception.toString()}' : '';
    return '$runtimeType: $message$detail';
  }

  /// For full debugging with stack trace
  String fullDebugString() {
    return '$this\nStackTrace:\n$stackTrace';
  }

  @override
  List<Object?> get props => [message, exception];
}

class NetworkFailure extends Failure {
  const NetworkFailure([dynamic exception, StackTrace? stackTrace])
      : super("Network error. Please check your internet connection.",
            exception, stackTrace);
}

class AuthFailure extends Failure {
  const AuthFailure([dynamic exception, StackTrace? stackTrace])
      : super("Auth error", exception, stackTrace);
}

class RefreshFailure extends Failure {
  const RefreshFailure([dynamic exception, StackTrace? stackTrace])
      : super("Refresh error", exception, stackTrace);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([dynamic exception, StackTrace? stackTrace])
      : super("Unexpected error", exception, stackTrace);
}
