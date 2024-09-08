import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/features/splash/domain/entities/splash_user.dart';


abstract class SplashRepository {
  Future<Either<Failure, SplashUser?>> getLoggedInUser();
}