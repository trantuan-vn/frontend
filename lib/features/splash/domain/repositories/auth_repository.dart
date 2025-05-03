import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> isAuthenticated();
}
