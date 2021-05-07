import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:istrayredux/globals.dart' as globals;

class SelectLocation extends StatefulWidget {
  @override
  createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  LatLng currentLocation = LatLng(13.7563, 100.5018);
  late GoogleMapController googleMapController;
  late CameraPosition position;
  @override
  initState() {
    var currentPosition = globals.getPosition();
    var currentLocation = LatLng(currentPosition!.latitude, currentPosition.longitude);
    super.initState();
    position = CameraPosition(target: currentLocation, zoom: 14.4);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location"),),
      body: WillPopScope(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                initialCameraPosition: position,
                onMapCreated: _onMapCreated,
                onCameraMove: _onCameraMove,
              ),
              Positioned(
                child: Icon(FontAwesomeIcons.mapMarker, color: Colors.red,),
              )
            ],
          ),
        ),
        onWillPop: () => _onWillPop(context),
      )
    );
  }
  _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }
  _onCameraMove(CameraPosition cameraPosition) {
    currentLocation = cameraPosition.target;
  }
  Future<bool> _onWillPop(BuildContext context) {
    Navigator.pop(context, currentLocation);
    return Future.value(false);
  }
}