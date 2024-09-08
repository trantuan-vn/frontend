part of 'splash_bloc.dart';


abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object?> get props => [];
}
class SplashLoadingError extends SplashState {
  final String errorMessage;

  const SplashLoadingError({required this.errorMessage});

  @override
  List<Object?> get props => [];
}

class SplashDoneLoading extends SplashState {
  late SplashUser? splashUser;
  
  SplashDoneLoading({required this.splashUser});

  @override
  List<Object?> get props => [];
}
