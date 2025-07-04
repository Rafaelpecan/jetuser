import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:jetrideruser/core/utils/validations_functions.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthModel.dart';
import 'package:jetrideruser/core/utils/validations_functions.dart';
import 'package:meta/meta.dart';
part 'register_screen_event.dart';
part 'register_screen_state.dart';

class RegisterScreenBloc extends Bloc<RegisterScreenEvent, RegisterScreenState> {

  final EmailAndPassAuth authRepo;

  RegisterScreenBloc({required this.authRepo}) : super(RegisterScreenState()) {
    on<RegisterUserNameChanged>(registerUserNameChanged);
    on<RegisterEmailChanged>(registerEmailChanged);
    on<RegisterPasswordChanged>(registerPasswordChanged);
    on<RegisterConfirmedPasswordChanged>(registerConfirmedPasswordChanged);
    on<RegisterSubmited>(registerSubmited); 
  }

  FutureOr<void> registerUserNameChanged(RegisterUserNameChanged event, Emitter<RegisterScreenState> emit) {
    emit(state.copyWith(username: event.username));
  }


  FutureOr<void> registerEmailChanged(RegisterEmailChanged event, Emitter<RegisterScreenState> emit) {
    emit(state.copyWith(email: event.email));
  }

  FutureOr<void> registerPasswordChanged(RegisterPasswordChanged event, Emitter<RegisterScreenState> emit) {
    emit(state.copyWith(password: event.password));
  }

  FutureOr<void> registerConfirmedPasswordChanged(RegisterConfirmedPasswordChanged event, Emitter<RegisterScreenState> emit) {
    emit(state.copyWith(confirmedPassword: event.confirmedPassword));
  }


  Future<void> registerSubmited(RegisterSubmited event, Emitter<RegisterScreenState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    
    try{
      await authRepo.signUp(EmailAndPassUser(email: state.email, password:  state.password, username: state.username));
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on Exception catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e)));
    }
  }
} 
