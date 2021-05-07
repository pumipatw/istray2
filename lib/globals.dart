import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dataRepository.dart';

DataRepository repository = DataRepository();

Future<Position> _determinePosition() async {
  return await Geolocator.getCurrentPosition();
}
Position? pos;
User? user;
updatePosition() async {
  try {
    pos = await _determinePosition();
  }
  catch (err) {
    print(err);
  }
}
Position? getPosition() {
  return pos;
}
GeoPoint positionToGeoPoint(Position position) {
  return GeoPoint(position.latitude, position.longitude);
}

LatLng geoPointToLatLng(GeoPoint geoPoint) {
  return LatLng(geoPoint.latitude, geoPoint.longitude);
}