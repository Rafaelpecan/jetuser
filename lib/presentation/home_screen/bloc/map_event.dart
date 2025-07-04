part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

class InitialMapEvent extends MapEvent {}

class OnRideRequestEvent extends MapEvent {
final Location userLocation;
OnRideRequestEvent({required this.userLocation});
}
