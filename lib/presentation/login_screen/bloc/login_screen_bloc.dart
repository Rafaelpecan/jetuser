import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetrideruser/core/utils/validations_functions.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthModel.dart';
import 'package:meta/meta.dart';
part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {

  final EmailAndPassAuth authRepo;

  LoginScreenBloc({required this.authRepo}) : super(LoginScreenState()) {
    on<LoginUserNameChanged>(loginUserNameChanged);
    on<LoginPasswordChanged>(loginPasswordChanged);
    on<LoginSubmited>(loginSubmited); 
  }


  FutureOr<void> loginUserNameChanged(LoginUserNameChanged event, Emitter<LoginScreenState> emit) {
    emit(state.copyWith(username: event.username));
  }


  FutureOr<void> loginPasswordChanged(LoginPasswordChanged event, Emitter<LoginScreenState> emit) {
    emit(state.copyWith(password: event.password));
  }


  Future<void> loginSubmited(LoginSubmited event, Emitter<LoginScreenState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    
    try{
      await authRepo.signIn(EmailAndPassUser(email: state.username, password:  state.password));
        emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on FirebaseAuthException catch (e) {  
        emit(state.copyWith(formStatus: SubmissionFailed((e.message ?? 'An error occurred'))));
    } catch (e) {
       emit(state.copyWith(formStatus: SubmissionFailed('Unknown error: $e')));
    }   
  }
} 
