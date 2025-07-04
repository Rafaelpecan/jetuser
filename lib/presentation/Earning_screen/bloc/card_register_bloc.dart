import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetrideruser/core/utils/validations_functions.dart';
import 'package:jetrideruser/domain/firebase_auth/creditcard.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/presentation/home_screen/bloc/geo_bloc.dart';
import 'package:meta/meta.dart';

part 'card_register_event.dart';
part 'card_register_state.dart';

class CardRegisterBloc extends Bloc<CardRegisterEvent, CardRegisterState> {

  final EmailAndPassAuth authRepo;

  CardRegisterBloc({required this.authRepo}) : super(CardRegisterState()) {
    on<CardNumberChanged>(cardNumberChanged);
    on<ValidChanged>(validChanged);
    on<OwnerChanged>(ownerChanged);
    on<CVVChanged>(cVMChanged);
    on<CPFChanged>(cpfChanged);
    on<RegisterSubmited>(registerSubmited); 
    
  }

  Future<void> cardNumberChanged(CardNumberChanged event, Emitter<CardRegisterState> emit) async {
    emit(state.copyWith(cardNumber: event.cardNumber));
  }


  Future<void> validChanged(ValidChanged event, Emitter<CardRegisterState> emit) async {
    emit(state.copyWith(valid: event.valid));
  }

  Future<void> ownerChanged(OwnerChanged event, Emitter<CardRegisterState> emit) async {
    emit(state.copyWith(owner: event.owner));
  }

  Future<void> cVMChanged(CVVChanged event, Emitter<CardRegisterState> emit) async {
    emit(state.copyWith(cvv: event.cvv));
  }

  Future<void> cpfChanged(CPFChanged event, Emitter<CardRegisterState> emit) async {
    emit(state.copyWith(cpf: event.cpf));
  }


  Future<void> registerSubmited(RegisterSubmited event, Emitter<CardRegisterState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try{

      CreditCard creditCard = CreditCard(
        number: state.cardNumber,
        valid: state.valid,
        titular: state.owner,
        cvv: state.cvv, 
      );

      creditCard.setBrand(state.cardNumber);

      await authRepo.addCpf(state.cpf);
      await authRepo.addCreditCard(creditCard);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on FirebaseAuthException catch (e) {  
        emit(state.copyWith(formStatus: SubmissionFailed((e.message ?? 'An error occurred'))));
    } catch (e) {
       emit(state.copyWith(formStatus: SubmissionFailed('Unknown error: $e')));
    }   
  }
}
