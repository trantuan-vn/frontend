import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/features/splash/domain/repositories/auth_repository.dart';

import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    final loginSuccess = await remoteDataSource.isAuthenticated();
    return Right(loginSuccess);
  }
}
