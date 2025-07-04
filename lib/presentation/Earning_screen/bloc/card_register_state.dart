part of 'card_register_bloc.dart';

@immutable
class CardRegisterState {
  final String cardNumber;
  bool get isValidcardNumber => cardNumber.isEmpty || isValidCardNumber(cardNumber);

  final String valid;
  bool get isValidvalid => valid.isEmpty || (valid.length == 7);

  final String owner;
  bool get isValidowner => owner.isEmpty || owner.trim().isNotEmpty;

  final String cvv;
  bool get isValidCVM => cvv.isEmpty || (cvv.length == 3);

  final String cpf;
  bool get isValidCPF => cpf.isEmpty || isValidCpf(cpf);

  final FormSubmissionStatus formStatus;

  CardRegisterState({
    this.cardNumber = "",
    this.valid = "",
    this.owner = "",
    this.cvv = "",
    this.cpf = "",
    this.formStatus = const InitialFormStatus(),
  });

  CardRegisterState copyWith({
    String? cardNumber,
    String? valid,
    String? owner,
    String? cvv,
    String? cpf,
    FormSubmissionStatus? formStatus,
  }) {
    return CardRegisterState(
      cardNumber: cardNumber ?? this.cardNumber,
      valid: valid ?? this.valid,
      owner: owner ?? this.owner,
      cvv: cvv ?? this.cvv,
      cpf: cpf ?? this.cpf,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final String exception;
  SubmissionFailed(this.exception);
}
