// features/login/presentation/bloc/login_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<PerformLogin>(_onPerformLogin);
  }

  Future<void> _onPerformLogin(
    PerformLogin event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await loginUseCase.call(NoParams());
    return result.fold(
      (failure) => emit(LoginError(message: failure.message)),
      (isSuccess) {
        if (isSuccess) {
          emit(LoginSuccess());
        } else {
          emit(const LoginError(message: 'Login failed'));
        }
      },
    );
  }
}
