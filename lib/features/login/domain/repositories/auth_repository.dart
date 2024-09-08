import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/features/login/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
}
