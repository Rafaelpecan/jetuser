part of 'login_screen_bloc.dart';

@immutable
class LoginScreenEvent {}

class LoginUserNameChanged extends LoginScreenEvent {
  final String? username;

  LoginUserNameChanged({this.username});
}

class LoginPasswordChanged extends LoginScreenEvent {
  final String? password;

  LoginPasswordChanged({this.password});
}

class LoginSubmited extends LoginScreenEvent{}
