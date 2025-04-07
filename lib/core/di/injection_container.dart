import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:smartconsultor/core/env/environment_configuration.dart';
import 'package:smartconsultor/core/hive/hive_manager.dart';
import 'package:smartconsultor/core/log/log_manager.dart';
import 'package:smartconsultor/core/network/network_info.dart';
import 'package:smartconsultor/features/login/data/datasources/user_local_data_source.dart';
import 'package:smartconsultor/features/login/data/datasources/user_remote_data_source.dart';
import 'package:smartconsultor/features/login/data/repositories/auth_repository_impl.dart';
import 'package:smartconsultor/features/login/domain/repositories/auth_repository.dart';
import 'package:smartconsultor/features/login/domain/usecases/auth_use_case.dart';
import 'package:smartconsultor/features/login/presentation/bloc/auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smartconsultor/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:smartconsultor/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:smartconsultor/features/splash/domain/repositories/splash_repository.dart';
import 'package:smartconsultor/features/splash/domain/usecases/splash_use_case.dart';
import 'package:smartconsultor/features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // init log manager
  LogManager.init();
  LogManager.logInfo('LogManager initialized');

  // init environment variables
  EnvironmentConfiguration.run();
  LogManager.logInfo('Environment variables loaded');

  // init Hive
  await HiveManager.initialize();
  LogManager.logInfo('Hive initialized');
  await HiveManager.registerAdapter();
  LogManager.logInfo('Hive adapters registered');

  // 1. Splash feature
  LogManager.logInfo('Initializing Splash feature...');
  // datasource
  sl.registerLazySingleton<SplashLocalDataSource>(
      () => SplashLocalDataSourceImpl());
  LogManager.logInfo('SplashLocalDataSource registered');

  // repository
  sl.registerLazySingleton<SplashRepository>(
      () => SplashRepositoryImpl(splashLocalDataSource: sl()));
  LogManager.logInfo('SplashRepository registered');

  // use case
  sl.registerLazySingleton(() => SplashUseCase(sl()));
  LogManager.logInfo('SplashUseCase registered');

  // bloc
  sl.registerFactory(() => SplashBloc(splashUseCase: sl()));
  LogManager.logInfo('SplashBloc registered');

  // 2. AUTH feature
  LogManager.logInfo('Initializing Auth feature...');
  // external
  sl.registerLazySingleton(() => http.Client());
  LogManager.logInfo('Http client registered');

  // core
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  LogManager.logInfo('Connectivity registered');

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));
  LogManager.logInfo('NetworkInfo registered');

  // datasource
  sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl());
  LogManager.logInfo('UserLocalDataSource registered');

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));
  LogManager.logInfo('UserRemoteDataSource registered');

  // repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));
  LogManager.logInfo('AuthRepository registered');

  // use case
  sl.registerLazySingleton(() => AuthUseCase(sl()));
  LogManager.logInfo('AuthUseCase registered');

  // bloc
  sl.registerFactory(() => AuthBloc(authUseCase: sl()));
  LogManager.logInfo('AuthBloc registered');

  LogManager.logInfo('All dependencies initialized successfully.');
}
