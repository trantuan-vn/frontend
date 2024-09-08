import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:smartconsultor/core/log/app_bloc_server.dart';

class LogManager {
  static init(){
    // ignore: prefer_const_constructors
    Bloc.observer = AppBlocObserver();

    Logger.level = Level.all;
    Logger.addLogListener((record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      }
    });    
  }
}