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
  // init environment variables
  EnvironmentConfiguration.run();
  // init Hive
  HiveManager.initialize();
  HiveManager.registerAdapter();
  // 1. Splash feature
  // datasource
  sl.registerLazySingleton<SplashLocalDataSource>(() => SplashLocalDataSourceImpl());
  // repository
  sl.registerLazySingleton<SplashRepository>(() => SplashRepositoryImpl(splashLocalDataSource: sl()));
  // use case
  sl.registerLazySingleton(() => SplashUseCase(sl()));
  // bloc
  sl.registerFactory(() => SplashBloc(splashUseCase: sl()));

  // 2. AUTH feature
  //external
  sl.registerLazySingleton(() => http.Client());
  //core
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));
  // datasource
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(client: sl()));
  // repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(localDataSource: sl(),remoteDataSource: sl(), networkInfo: sl()));
  // use case
  sl.registerLazySingleton(() => AuthUseCase(sl()));
  // bloc
  sl.registerFactory(() => AuthBloc(authUseCase: sl()));
}

