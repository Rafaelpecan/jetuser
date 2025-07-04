part of 'register_screen_bloc.dart';

@immutable
class RegisterScreenEvent {}


class RegisterUserNameChanged extends RegisterScreenEvent {
  final String? username;

  RegisterUserNameChanged({this.username});
}

class RegisterEmailChanged extends RegisterScreenEvent {
  final String? email;

  RegisterEmailChanged({this.email});
}

class RegisterPasswordChanged extends RegisterScreenEvent {
  final String? password;

  RegisterPasswordChanged({this.password});
}

class RegisterConfirmedPasswordChanged extends RegisterScreenEvent {
  final String? confirmedPassword;

  RegisterConfirmedPasswordChanged({this.confirmedPassword});
}

class RegisterSubmited extends RegisterScreenEvent{}

