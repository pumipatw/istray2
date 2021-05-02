import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}
Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
  final Pet pet = Pet.fromSnapshot(snapshot);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      child: InkWell(
        child: ListTile(
          leading: Hero(tag: 'pet', child: (pet.pictureUrl != null) ? ClipRect(
            child: Container(
              width: 100,
              height: 100,
              child: Image(image: NetworkImage(pet.pictureUrl!)),
            ),
          ) : Image.asset('images/icon/icon.png')),
          title: Text(pet.type!),
          subtitle: Text(pet.size! + " " + DateFormat('dd MMM hh:mm').format(pet.date!.toDate())),
      ),
        onTap: () {
          Navigator.pushNamed(context, "/detail",arguments: pet);
        },
      ),
    )
  );
}
