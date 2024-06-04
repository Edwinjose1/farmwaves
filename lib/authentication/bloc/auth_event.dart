part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginRequested extends AuthEvent{
  final String email;
  final String password;
  AuthLoginRequested({required this.email,required this.password});


}
final class AuthSignupRequested extends AuthEvent{
  final String username;
  final String email;
  final String password;
  AuthSignupRequested({required this.username,required this.email,required this.password});


}