import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Pet.dart';
import 'globals.dart' as globals;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  final Map<String, Marker> _marker = {};
  LatLng _center;
  @override
  void initState() {
    super.initState();
    Position _x = globals.getPosition();
    _center = LatLng(_x.latitude, _x.longitude);
  }
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    setState(() {
      _marker.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    print(_center);
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 15.0,
      ),
      markers: _marker.values.toSet(),
    );
  }
}
