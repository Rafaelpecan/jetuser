part of 'geo_bloc.dart';

@immutable
sealed class GeoEvent {}

class AddressChanged extends GeoEvent {
  final String address;

  AddressChanged({required this.address});
}

class AddressSubmitted extends GeoEvent {
  final Position? userNewPosition;
  AddressSubmitted({required this.userNewPosition});
}

class NewAddressSubmitted extends GeoEvent {
  final SearchplaceModel? predictionsPlace;
  NewAddressSubmitted({required this.predictionsPlace});
}


class LoadUserLocation extends GeoEvent {}

class ResetSearch extends GeoEvent {}
