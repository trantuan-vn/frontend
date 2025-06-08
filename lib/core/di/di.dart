import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:smartconsultor/core/di/dio_service.dart';

import 'di.config.dart';

final sl = GetIt.instance;
bool _diInitialized = false;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() {
  if (_diInitialized) return;
  _diInitialized = true;
  sl.init();
}
