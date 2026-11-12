part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadLoadingState extends AuthState {}

final class LoginSuccessState extends AuthState {}

final class LoginErrorState extends AuthState {
  final String message;
  LoginErrorState(this.message);
}

final class RegisterSuccessState extends AuthState {
  final String message;
  RegisterSuccessState(this.message);
}

final class RegisterErrorState extends AuthState {
  final String message;
  RegisterErrorState(this.message);
}

final class ForgetPasswordSuccessState extends AuthState {
  final String message;
  ForgetPasswordSuccessState(this.message);
}

final class ForgetPasswordErrorState extends AuthState {
  final String message;
  ForgetPasswordErrorState(this.message);
}
