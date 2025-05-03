import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smartconsultor/features/splash/domain/usecases/check_auth_usecase.dart';

import '../../../../core/usecases/use_case.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAuthUseCase checkAuthUseCase;

  SplashBloc(this.checkAuthUseCase) : super(SplashInitial()) {
    on<CheckAuthentication>(_onCheckAuthentication);
  }

  Future<void> _onCheckAuthentication(
    CheckAuthentication event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    final result = await checkAuthUseCase.call(NoParams());
    return result.fold(
      (failure) =>
          emit(SplashError(message: 'Error checking authentication: $failure')),
      (isAuthenticated) {
        if (isAuthenticated)
          return emit(SplashAuthenticated());
        else
          return emit(SplashUnauthenticated());
      },
    );
  }
}
