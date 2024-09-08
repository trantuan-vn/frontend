part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent extends Equatable {
  const SplashEvent();
}

class SplashLoadData extends SplashEvent {
  @override
  List<Object?> get props => [];
}
