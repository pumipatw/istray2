import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'models/Pet.dart';
import 'globals.dart' as globals;

class PetContainer extends StatelessWidget {
  final bool foruser;
  PetContainer(this.foruser);
  @override
  Widget build(BuildContext context) {
    if(foruser) return StreamBuilder<QuerySnapshot>(
        stream: globals.repository.getStream(null),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data!.docs);
        });
    else return StreamBuilder<QuerySnapshot>(
        stream: globals.repository.getStream(globals.user),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data!.docs);
        });
  }
}
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  List<Pet> x = snapshot.map((data) => Pet.fromSnapshot(data)).toList();
  Position? pos = globals.getPosition();
  x.forEach((pet) {pet.calculateDistance(pos!);});
  x.sort((a,b) {
    if(a.distance < b.distance) return -1;
    else if(a.distance > b.distance) return 1;
    return 0;
  });
  var max = (x.length > 10) ? 10 : x.length;
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: x.getRange(0, max).map((pet) => _buildListItem(context, pet)).toList()
  );
}
Widget _buildListItem(BuildContext context, Pet pet) {
  pet.calculateDistance(globals.getPosition()!);
  String near = (pet.distance > 1000.0) ? "${(pet.distance/1000).toStringAsFixed(0)} km" : "${pet.distance.toStringAsFixed(2)} m";
  return Container(
    key: Key("$pet"),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      elevation: 3.0,
      child: InkWell(
        child: ListTile(
          leading: Hero(tag: '$pet', child: (pet.pictureUrl != null) ? ClipRect(
            child: Container(
              width: 100,
              height: 100,
              child: Image(image: NetworkImage(pet.pictureUrl!)),
            ),
          ) : Image.asset('images/icon/icon.png')),
          title: Text(pet.type),
          subtitle: Text(pet.size + " " + DateFormat('dd MMM hh:mm').format(pet.date.toDate()) + "\nLast sight near you: " + near),
      ),
        onTap: () {
          Navigator.pushNamed(context, "/detail",arguments: pet);
        },
      ),
    )
  );
}
