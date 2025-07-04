import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jetrideruser/presentation/botton_navigator/bottonNavigator.dart';
import 'package:jetrideruser/presentation/drawer/costumdrawer.dart';
import 'package:jetrideruser/presentation/home_screen/bloc/geo_bloc.dart';
import 'package:jetrideruser/presentation/home_screen/bloc/map_bloc.dart';
import 'package:jetrideruser/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const CameraPosition defaultCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? _newGoogleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("JETRIDER"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: const CustomBottomNavigator(),
      body: BlocBuilder<GeoBloc, GeoState>(
        builder: (context, geoState) {
          return Stack(
            children: [
              BlocBuilder<MapBloc, MapState>(
                builder: (context, mapState) => _buildGoogleMap(mapState),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildLocationContainer(geoState),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Builds the Google Map widget
  Widget _buildGoogleMap(MapState mapState) {
    if (mapState is MapStatusSucess) {
      return GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        markers: mapState.driversMarkSet ?? <Marker>{},
        initialCameraPosition: HomeScreen.defaultCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          if (!_controllerGoogleMap.isCompleted) {
            _controllerGoogleMap.complete(controller);
          } else {
            _controllerGoogleMap = Completer();
            _controllerGoogleMap.complete(controller);
          }
          _newGoogleMapController = controller;
          _newGoogleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(mapState.cameraPosition),
          );
        },
      );
    }else if (mapState is RequestSucess){
      return GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        markers: mapState.driversMarkSet ?? <Marker>{},
        initialCameraPosition: HomeScreen.defaultCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          if (!_controllerGoogleMap.isCompleted) {
            _controllerGoogleMap.complete(controller);
          } else {
            _controllerGoogleMap = Completer();
            _controllerGoogleMap.complete(controller);
          }
          _newGoogleMapController = controller;
          _newGoogleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(mapState.cameraPosition),
          );
        },
      );
    } 
    else if (mapState is MapErrorState) {
      return const Center(child: Text("Erro de conexão"));
    }
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds the bottom location search container
  Widget _buildLocationContainer(GeoState state) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeIn,
      child: Container(
        height: 220.0,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 128, 192),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<GeoBloc>().add(ResetSearch());
                      Navigator.of(context).pushNamed(AppRoutes.searchplace);
                    },
                    child: const Icon(
                      Icons.add_location_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Localização Atual",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      _buildLocationText(state),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              const Divider(height: 1, thickness: 1, color: Colors.white),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
                      ),
                      onPressed: () {
                        _requestRide(context, state);
                      },
                      child: const Text(
                        'Pedir passeio',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays the current location text based on the state
  Widget _buildLocationText(GeoState state) {
    if (state.formStatus is FormSubmitting) {
      return const CircularProgressIndicator();
    } else if (state.formStatus is SubmissionFailed) {
      return const Text(
        "Failed to fetch location",
        style: TextStyle(color: Colors.red),
      );
    } else if (state.formStatus is SubmissionSuccess) {
      final address = (state.formStatus as SubmissionSuccess).address?.address;
      return Text(
        address ?? "Sem endereço",
        style: const TextStyle(color: Colors.white, fontSize: 12),
      );
    }
    return Text(
      state.address ?? "Sem endereço",
      style: const TextStyle(color: Colors.white, fontSize: 12),
    );
  }

  void _requestRide(BuildContext context, GeoState state) {
  if (state.formStatus is SubmissionSuccess) {
    final userLocation = (state.formStatus as SubmissionSuccess).address;
    
    if (userLocation != null && userLocation.address != null) {
      Fluttertoast.showToast(
        msg: "Ride requested from: ${userLocation.address}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      context.read<MapBloc>().add(OnRideRequestEvent(userLocation: userLocation));

      // Example: Navigate to ride confirmation screen
      //Navigator.of(context).pushNamed(AppRoutes.rideConfirmation);
    } else {
      Fluttertoast.showToast(
        msg: "User location is unavailable.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: "Cannot request ride: Location not available.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      );
    }
  }
}
