import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/domain/geolocator/ActiveNearbyAvailableDrivers.dart';
import 'package:jetrideruser/domain/geolocator/geoLocationModel.dart';
import 'package:jetrideruser/domain/geolocator/geofireManager.dart';
import 'package:jetrideruser/domain/geolocator/geolocator.dart';
import 'package:jetrideruser/domain/payament/cielo_payment.dart';
import 'package:meta/meta.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final EmailAndPassAuth authRepo;

  MapBloc({required this.authRepo}) : super(MapInitial()) {
    on<InitialMapEvent>(_handleInitialMapEvent);
    on<OnRideRequestEvent>(_onRideRequest);
  }

Future<void> _handleInitialMapEvent(InitialMapEvent event, Emitter<MapState> emit) async {
  emit(MapLoadingState());

  try {
    // Locate user position
    final hasPermission = await GeolocatorUser.LocateUserPosition();
    if (!hasPermission) throw Exception("Location permission denied");

    final userPosition = await Geolocator.getCurrentPosition();
    final cameraPosition = CameraPosition(
      target: LatLng(userPosition.latitude, userPosition.longitude),
      zoom: 15,
    );

    emit(MapStatusSucess(cameraPosition: cameraPosition, driversMarkSet: {}));

    // Initialize Geofire and listen for active drivers
    final completer = Completer<void>();

    Geofire.initialize("activeDrivers");
    final geoQueryStream = Geofire.queryAtLocation(
        userPosition.latitude, userPosition.longitude, 5);

    geoQueryStream?.listen((map) async {

      await _handleGeofireUpdates(map);

      if (!emit.isDone) {
        emit(MapStatusSucess(
          cameraPosition: cameraPosition,
          driversMarkSet: _generateMarkers(),
        ));
      }
    },onDone: () {
      completer.complete(); // Mark as done when the listener finishes
    }
  );

  await completer.future; // Wait for the stream to finish
  } catch (e) {
    emit(MapErrorState(e.toString()));
  }
}

  Future<void> _handleGeofireUpdates(map) async {
    if (map == null){
      return;
    };
    final callBack = map['callBack'];

    switch (callBack) {
      case Geofire.onKeyEntered:
        GeofireManager.addDriver(
          Activenearbyavailabledrivers(
            map['key'],
            map['latitude'],
            map['longitude'],
          ),
        );
        break;

      case Geofire.onKeyExited:
        GeofireManager.removeDriver(map['key']);
        break;

      case Geofire.onKeyMoved:
        GeofireManager.updateDriver(
          Activenearbyavailabledrivers(
            map['key'],
            map['latitude'],
            map['longitude'],
          ),
        );
        break;

      case Geofire.onGeoQueryReady:
        // No additional action needed for now.
        break;
    }
  }

  Set<Marker>? _generateMarkers() {
    return GeofireManager.activenearbyavailabledriversList.map((driver) {
      return Marker(
        markerId: MarkerId(driver.driverId!),
        position: LatLng(driver.locationLatitude!, driver.locationLongitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      );
    }).toSet();
  }

  Future<void> _onRideRequest(OnRideRequestEvent event, Emitter<MapState> emit) async {

    emit(MapLoadingState());
    //Pagamento 
    
    String payId = '';
    final CieloPayment cieloPayment = CieloPayment();
    try {
      if (authRepo.user!.creditCard != null) {
        payId = await cieloPayment.authorize(
        creditcard: authRepo.user!.creditCard!, 
        price: 70, 
        orderId: '1000', 
        user: authRepo.user!);

        debugPrint("Sucess $payId");
      }
    } on Exception catch (e) {
  // TODO
  }

  try{
    await cieloPayment.capture(payId);
  } catch (e){
    return;
  }
  

    try{
      authRepo.requestRide(event.userLocation);
      final cameraPosition = CameraPosition(
      target: LatLng(event.userLocation.latitude, event.userLocation.longitude),
      zoom: 15,
    );

for (var driver in GeofireManager.activenearbyavailabledriversList) {
  if (driver.driverId != null) {
    authRepo.sendNotificationRideRequest(driver.driverId!);
  }
}

  emit(RequestSucess(
    cameraPosition: cameraPosition,
    driversMarkSet: {},
    ));
    }catch(e){
      emit(MapErrorState(e.toString()));
    }
  }
}
