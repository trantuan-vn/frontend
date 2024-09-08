part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}
@immutable
class AuthInitialState extends AuthState {}

@immutable
class AuthLoadingState extends AuthState {}

@immutable
class AuthAuthenticatedState extends AuthState {
  final User user;

  const AuthAuthenticatedState({required this.user});

  @override
  List<Object> get props => [user];
}
@immutable
class AuthUnauthenticatedState extends AuthState {
  final String errorMessage;

  const AuthUnauthenticatedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
@immutable
class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
@immutable
class Empty extends AuthState{
}