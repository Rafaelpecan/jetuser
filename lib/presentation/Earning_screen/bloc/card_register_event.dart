part of 'card_register_bloc.dart';

@immutable
sealed class CardRegisterEvent {}

class CardNumberChanged extends CardRegisterEvent {
  final String? cardNumber;
  CardNumberChanged({this.cardNumber});
}

class ValidChanged extends CardRegisterEvent {
  final String? valid;
  ValidChanged({this.valid});
}

class OwnerChanged extends CardRegisterEvent {
  final String? owner;
  OwnerChanged({this.owner});
}

class CVVChanged extends CardRegisterEvent {
  final String? cvv;
  CVVChanged({this.cvv});
}

class CPFChanged extends CardRegisterEvent {
  final String? cpf;
  CPFChanged({this.cpf});
}

class RegisterSubmited extends CardRegisterEvent{

}