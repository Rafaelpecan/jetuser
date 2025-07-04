import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jetrideruser/domain/geolocator/geoLocationModel.dart';
import 'package:jetrideruser/domain/geolocator/geocodemanager.dart';
import 'package:jetrideruser/domain/geolocator/geolocator.dart';
import 'package:jetrideruser/domain/geolocator/searchplacemanager.dart';
import 'package:jetrideruser/domain/geolocator/searchplacemodel.dart';
import 'package:meta/meta.dart';
part 'geo_event.dart';
part 'geo_state.dart';

class GeoBloc extends Bloc<GeoEvent, GeoState> {
  GeoBloc() : super(GeoState(address: '', formStatus: const InitialFormStatus())) {
    on<ResetSearch>(onResetSearch);
    on<AddressChanged>(onAddressChanged);
    on<AddressSubmitted>(onAddressSubmitted);
    on<LoadUserLocation>(onLoadUserLocation);
    on<NewAddressSubmitted>(onNewAddressSubmitted);
  }

  Future<void> onAddressChanged(AddressChanged event, Emitter<GeoState> emit) async {
    emit(state.copyWith(address: event.address));
    if (event.address.length > 2) {
      try {
        emit(state.copyWith(formStatus: FormSubmitting()));
        final results = await SearchplaceManager(event.address).findPlaceAutoCompleteSearch();
        emit(state.copyWith(formStatus: Formchanging(results)));
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(Exception('Failed to fetch location'))));
      }
    }
  }

  Future<void> onAddressSubmitted(AddressSubmitted event, Emitter<GeoState> emit) async {
    try {
      emit(state.copyWith(formStatus: FormSubmitting()));
      GeoCodeManager geoManager = GeoCodeManager();
      Location location = await geoManager.fetchAddress(lat: event.userNewPosition!.latitude, long: event.userNewPosition!.longitude);
      emit(state.copyWith(formStatus: SubmissionSuccess(address: location)));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception('Submission failed'))));
    }
  }

  Future<void> onLoadUserLocation(LoadUserLocation event, Emitter<GeoState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {

      if(await GeolocatorUser.LocateUserPosition()){
      var userCurrentPosition = await Geolocator.getCurrentPosition();
      LatLng latlngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
      CameraPosition cameraPosition = CameraPosition(target: latlngPosition, zoom: 15);

      final latitude = cameraPosition.target.latitude;
      final longitude = cameraPosition.target.longitude;
      GeoCodeManager geoManager = GeoCodeManager();
      Location loc = await geoManager.fetchAddress(lat: latitude, long: longitude);

      emit(state.copyWith(
        address: loc.address,
        formStatus: SubmissionSuccess(address: loc),
      ));
    }else{
      emit(state.copyWith(formStatus: SubmissionFailed(Exception('Failed to fetch location'))));
    }
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception('Failed to fetch location'))));
    }
  }

  Future<void> onNewAddressSubmitted(NewAddressSubmitted event, Emitter<GeoState> emit) async {
    try {
      emit(state.copyWith(formStatus: FormSubmitting()));
      final location= await SearchplaceManager(event.predictionsPlace?.mainText ?? '').findPlaceAById(event.predictionsPlace?.placeId);
      print(location);
      emit(state.copyWith(formStatus: SubmissionSuccess(address: location)));
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(Exception('Failed to fetch location'))));
    }
  }

  Future<void> onResetSearch(ResetSearch event, Emitter<GeoState> emit) async {
  emit(GeoState(
    address: '', // Clear the address
    formStatus: const InitialFormStatus(), // Reset the form status
  ));
}
}
