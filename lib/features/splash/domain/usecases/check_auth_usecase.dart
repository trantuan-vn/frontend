import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final result = await repository.isAuthenticated();
    return result.fold(
      (failure) => Left(failure),
      (isAuthenticated) {
        return Right(isAuthenticated);
      },
    );
  }
}
