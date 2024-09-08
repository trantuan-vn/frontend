import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartconsultor/features/login/domain/entities/user.dart';
import 'package:smartconsultor/features/login/domain/usecases/auth_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc({required this.authUseCase}) : super(AuthInitialState()){
    on<AuthEvent>((event, emit) async {
    emit(AuthLoadingState());

    if (event is SignInEvent) {
      // Xử lý sự kiện đăng nhập
      
      try {
        final result = await authUseCase(Params(username: event.username,password: event.password));

        result.fold(
          (failure) async {
            // Handle the failure case
            emit(const AuthUnauthenticatedState(errorMessage: 'Invalid credentials'));
          },
          (user) async {
            // Handle the success case
            emit(AuthAuthenticatedState(user: user));
          },
        );
      } catch (e) {
        emit(const AuthErrorState(errorMessage: 'An error occurred'));
      }
    } else if (event is SignOutEvent) {
      // Xử lý sự kiện đăng xuất
      // Thực hiện đăng xuất
      emit(const AuthUnauthenticatedState(errorMessage: 'SignOut'));
    } else if (event is RefreshTokenEvent) {
      // Xử lý sự kiện làm mới token

      // Thực hiện làm mới token và kiểm tra thành công hay không
      // Giả sử refreshToken là hợp lệ
      //emit(AuthAuthenticatedState(username: 'tuanta'));
    }      
    });
  }
}