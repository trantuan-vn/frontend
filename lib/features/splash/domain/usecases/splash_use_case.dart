
import 'package:dartz/dartz.dart';
import 'package:smartconsultor/core/error/failures.dart';
import 'package:smartconsultor/core/usecases/use_case.dart';
import 'package:smartconsultor/features/splash/domain/entities/splash_user.dart';

import 'package:smartconsultor/features/splash/domain/repositories/splash_repository.dart';

class SplashUseCase implements UseCase<SplashUser?, NoParams>{
  final SplashRepository splashRepository;

  SplashUseCase(this.splashRepository);

  @override
  Future<Either<Failure, SplashUser?>> call(NoParams params) async {
    return await splashRepository.getLoggedInUser();
  }
}
