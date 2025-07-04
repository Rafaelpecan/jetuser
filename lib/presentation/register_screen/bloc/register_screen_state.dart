part of 'register_screen_bloc.dart';

@immutable
class RegisterScreenState {

  final String username;
  bool get isValidUsername => username.trim().split(' ').length > 1;

  final String email;
  bool get isValidemail => isValidEmail(email);

  final String password;
  bool get isValidPassword => password.isEmpty || password.length > 5;

  final String confirmedPassword;
  bool get isValidConfirmedPassword => confirmedPassword == password;

  final FormSubmissionStatus formStatus;

  RegisterScreenState({
    this.username = "",
    this.email = "",
    this.password = "",
    this.confirmedPassword = "",
    this.formStatus = const InitialFormStatus()
  });

    RegisterScreenState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmedPassword,
    FormSubmissionStatus? formStatus,
  }){
    return RegisterScreenState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      formStatus: formStatus ?? this.formStatus
      );
    }
}


abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

 class InitialFormStatus extends FormSubmissionStatus{
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final Exception exception;

  SubmissionFailed(this.exception);
} 

