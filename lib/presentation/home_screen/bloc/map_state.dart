part of 'map_bloc.dart';

class MapState {}

class MapInitial extends MapState {}

class MapLoadingState extends MapState {}

class MapErrorState extends MapState {
  MapErrorState(String s);
}

class MapStatusSucess extends MapState {

  final CameraPosition cameraPosition;
  Set<Marker>? driversMarkSet;
  MapStatusSucess({required this.cameraPosition, required this.driversMarkSet});
}

class RequestSucess extends MapState {
  final CameraPosition cameraPosition;
  Set<Marker>? driversMarkSet;
  RequestSucess({required this.cameraPosition, required this.driversMarkSet});
}






