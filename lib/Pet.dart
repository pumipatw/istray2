import 'package:flutter/material.dart';
class Pet {
  final int id;
  final String type;
  final String breed;
  final double distance;
  final int age;
  Pet(this.id, this.type, this.breed, this.age, this.distance);
}
class PetContainer extends StatelessWidget {
  const PetContainer({
    Key key,
    @required this.pet,
  }) : super(key: key);

  final List<Pet> pet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          for(Pet i in pet)
            PetDetail(i)
        ],
      ),
    );
  }
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
            subtitle: Text(pet.type + ' breed: '+ pet.breed + '\nDistance: '+ pet.distance.toStringAsFixed(0) +' m \nAge: ' + pet.age.toString()),
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