import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'globals.dart' as globals;
import 'models/Pet.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? _center;
  Set<Marker> _markers = HashSet<Marker>();
  late List<Marker> mark;
  @override
  void initState() {
    super.initState();
    Position? _x = globals.getPosition();
    if(_x == null) {
      _center = LatLng(13.7563, 100.5018);
    }
    else {
      _center = LatLng(_x.latitude, _x.longitude);
    }
    super.initState();
  }
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    mark = await getMarker();
    mark.forEach((element) {
      addMarker(element);
    });
  }
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center!,
        zoom: 15.0,
      ),
      markers: _markers,
    );
  }
  void addMarker(Marker x) {
    setState(() {
      _markers.add(x);
    });
    print(_markers);
  }
}
Future<List<Marker>> getMarker() async {
  List<Marker> result = [];
  await FirebaseFirestore.instance.collection('pets').get().then((QuerySnapshot x) {
    if(x.docs.isNotEmpty) {
      x.docs.forEach((element) {
        result.add(toMarker(element));
      });
    }
  });
  return result;
}
Marker toMarker(QueryDocumentSnapshot x) {
  Pet t = Pet.fromSnapshot(x);
  StringBuffer y = StringBuffer();
  if(t.breed != null) y.write("Breed: " + t.breed! + '\n');
  y.write("Size: " + t.size + '\n');
  y.write("Condition: " + t.condition + '\n');
  y.write("Last Found: " + DateFormat("dd MMM hh:mm").format(t.date.toDate().toLocal()));
  return new Marker(
    markerId: MarkerId(t.reference.id),
    infoWindow: InfoWindow(
      title: t.type,
      snippet: y.toString()
    ),
    position: globals.geoPointToLatLng(t.location)
  );
}