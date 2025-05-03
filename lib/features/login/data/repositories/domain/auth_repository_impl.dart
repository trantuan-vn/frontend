import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/core/error/result.dart';
import 'package:smartconsultor/core/network/network_info.dart';
import 'package:smartconsultor/features/login/data/datasources/remote/login_mobile_desktop.dart';
import 'package:smartconsultor/features/login/data/datasources/remote/login_web.dart';
import 'package:smartconsultor/features/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginWeb _loginWeb;
  final LoginMobileDesktop _loginMobileDesktop;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required LoginWithKeycloak loginWithKeycloak,
    required NetworkInfo networkInfo,
  })  : _loginWithKeycloak = loginWithKeycloak,
        _networkInfo = networkInfo;

  @override
  Future<Result<bool>> login() async {
    if (!await _networkInfo.isConnected()) {
      return Left(NetworkFailure(Exception('No Internet Connection')));
    }
    return _loginWithKeycloak.login();
  }
}
