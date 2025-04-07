import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:smartconsultor/core/log/app_bloc_server.dart';

class LogManager {
  static final Logger _logger = Logger(
    level: Level.all,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
      colors: kDebugMode,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void init() {
    Bloc.observer = const AppBlocObserver();
    logInfo('LogManager initialized');
  }

  static void logInfo(String message) {
    if (kDebugMode) _logger.i(message);
  }

  static void logDebug(String message) {
    if (kDebugMode) _logger.d(message);
  }

  static void logWarning(String message) {
    if (kDebugMode) _logger.w(message);
  }

  static void logError(String message,
      {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
