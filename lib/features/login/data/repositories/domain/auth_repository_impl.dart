import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/core/error/result.dart';
import 'package:smartconsultor/core/log/log_manager.dart';
import 'package:smartconsultor/core/network/network_info.dart';
import 'package:smartconsultor/features/login/data/datasources/remote/login_mobile_desktop.dart';
import 'package:smartconsultor/features/login/data/datasources/remote/login_web.dart';
import 'package:smartconsultor/features/login/domain/repositories/auth_repository.dart';

@Singleton()
class AuthRepositoryImpl implements AuthRepository {
  final LoginWeb _loginWeb;
  final LoginMobileDesktop _loginMobileDesktop;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required LoginWeb loginWeb,
    required LoginMobileDesktop loginMobileDesktop,
    required NetworkInfo networkInfo,
  })  : _loginWeb = loginWeb,
        _loginMobileDesktop = loginMobileDesktop,
        _networkInfo = networkInfo;

  @override
  Future<Result<bool>> login() async {
    if (!await _networkInfo.isConnected()) {
      return Left(NetworkFailure(Exception('No Internet Connection')));
    }
    try {
      final result =
          kIsWeb ? await _loginWeb.login() : await _loginMobileDesktop.login();

      if (result == null) {
        return Left(RefreshFailure(Exception('Token is null')));
      }

      return Right(true);
    } catch (e, s) {
      LogManager.logError('RefreshToken error', error: e, stackTrace: s);
      return Left(RefreshFailure(e, s));
    }
  }
}
