
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/core/usecases/use_case.dart';
import 'package:smartconsultor/features/login/domain/entities/user.dart';
import 'package:smartconsultor/features/login/domain/repositories/auth_repository.dart';

class AuthUseCase implements UseCase<User, Params>{
  final AuthRepository authRepository;

  AuthUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await authRepository.login(params.username, params.password);
  }
}

class Params extends Equatable {
  final String username;
  final String password;

  const Params({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}