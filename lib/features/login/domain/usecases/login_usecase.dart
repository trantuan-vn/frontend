import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/result.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<bool>> call(NoParams params) async {
    final result = await repository.login();
    return result.fold(
      (failure) => Left(failure),
      (isSuccess) {
        return Right(isSuccess);
      },
    );
  }
}
