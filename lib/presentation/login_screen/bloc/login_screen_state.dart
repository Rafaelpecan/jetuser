part of 'login_screen_bloc.dart';

@immutable
 class LoginScreenState {

  final String username;
  bool get isValidUsername => isValidEmail(username);

  final String password;
  bool get isValidPassword => password.length > 5;

  final FormSubmissionStatus formStatus;

  LoginScreenState({
    this.username= "",
    this.password = "",
    this.formStatus = const InitialFormStatus()
  });

  LoginScreenState copyWith({
    String? username,
    String? password,
    FormSubmissionStatus? formStatus
  }){
    return LoginScreenState(
      username: username ?? this.username,
      password: password ?? this.password,
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
  final String exception;

  SubmissionFailed(this.exception);
} 
