import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Pet.dart';
import 'globals.dart' as globals;

class PetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: globals.repository.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.docs);
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
  final pet = Pet.fromSnapshot(snapshot);
  if(pet == null) {
    return Container();
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      child: InkWell(
        child: ListTile(
          leading: Text("img"),
          title: Text(pet.type),
          subtitle: Text(' '),
      ),
        onTap: () {
          Navigator.pushNamed(context, "/detail", arguments: pet);
        },
      ),
    )
  );
}
class PetDetail extends StatelessWidget {
  final Pet pet;
  PetDetail(this.pet);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          child: ListTile(
            leading: Text("img"),
            title: Text(pet.type),
            subtitle: Text(' '),
          ),
          onTap: () {
            Navigator.pushNamed(context, "/detail", arguments: pet);
          },
        )
    );
  }
}

class PetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pet args = ModalRoute.of(context).settings.arguments as Pet;
    return Scaffold(
      appBar: AppBar(),
      body: Text("Pet type: " + args.type + "\n" + args.type + " breed: " + args.breed),
    );
  }
}