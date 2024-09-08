import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/exceptions.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:smartconsultor/features/splash/domain/entities/splash_user.dart';
import 'package:smartconsultor/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource splashLocalDataSource;

  
  SplashRepositoryImpl({
    required this.splashLocalDataSource, 
  });

  @override
  Future<Either<Failure, SplashUser?>> getLoggedInUser() async {
    try {
      var splashUserModel = await splashLocalDataSource.getLoggedInUser();
      // tra ket qua login thanh cong
      return Right(splashUserModel);    
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}