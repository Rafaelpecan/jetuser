import 'package:flutter/material.dart';
import 'package:jetrideruser/domain/geolocator/ActiveNearbyAvailableDrivers.dart';

class GeofireManager {

    static List<Activenearbyavailabledrivers> activenearbyavailabledriversList = [];


    static void addDriver(Activenearbyavailabledrivers driverNew){
        activenearbyavailabledriversList.add(driverNew);
    }

    static void removeDriver(String driverId){
        activenearbyavailabledriversList.removeWhere((Element) => Element.driverId == driverId);
    }

    static void updateDriver(Activenearbyavailabledrivers driverWhoMove){

        int indexNumber = activenearbyavailabledriversList.indexWhere((element) => element.driverId == driverWhoMove.driverId);
        activenearbyavailabledriversList[indexNumber].locationLatitude = driverWhoMove.locationLatitude;
        activenearbyavailabledriversList[indexNumber].locationLongitude = driverWhoMove.locationLongitude; 
    }
}