part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class AuthSuccess extends AuthState {
  final String token;

  AuthSuccess({required this.token});

  @override
  List<Object> get props => [token];
}

class SignupSuccess extends AuthState {
  SignupSuccess();
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
