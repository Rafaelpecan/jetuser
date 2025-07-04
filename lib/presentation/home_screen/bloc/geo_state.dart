part of 'geo_bloc.dart';

@immutable
class GeoState {

  final String? address;
  bool get isValidCep => (address?.isNotEmpty ?? false) && ((address?.length ?? false) == 10);

  final FormSubmissionStatus? formStatus;

  GeoState({this.address, this.formStatus});

  GeoState copyWith({
    String? address, 
    FormSubmissionStatus? formStatus
  }){
    return GeoState(
      address: address ?? this.address,
      formStatus:  formStatus ?? this.formStatus
    );
  }
}

class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus{
  const InitialFormStatus();
}

class Formchanging extends FormSubmissionStatus{
  List<SearchplaceModel> places;
  Formchanging(this.places);
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {
  SubmissionSuccess({required this.address});
  final Location address;
}

class SubmissionFailed extends FormSubmissionStatus {
  final Exception exception;

  SubmissionFailed(this.exception);
}



