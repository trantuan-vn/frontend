import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smartconsultor/core/usecases/use_case.dart';
import 'package:smartconsultor/features/splash/domain/entities/splash_user.dart';
import 'package:smartconsultor/features/splash/domain/usecases/splash_use_case.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashUseCase splashUseCase;

  SplashBloc({required this.splashUseCase}) : super(SplashInitial()){
    on<SplashEvent>((event, emit) async {
      // Thực hiện logic load data ở đây
      if (event is SplashLoadData) {
        try {
          final result = await splashUseCase(NoParams());

          result.fold(
            (failure) async {
              // Handle the failure case
              emit(const SplashLoadingError(errorMessage: 'An error occurred'));
            },
            (user) async {
              // Khi hoàn tất, chuyển sang trạng thái đã hoàn thành
              emit(SplashDoneLoading(splashUser: user));
            },
          );
        } catch (e) {
          emit(const SplashLoadingError(errorMessage: 'An error occurred'));
        }
      }
    });
  }
}
