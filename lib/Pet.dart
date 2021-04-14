import 'package:flutter/material.dart';
class Pet {
  final int id;
  final String type;
  final String breed;
  final double distance;
  final int age;
  final double lat;
  final double lng;
  Pet(this.id, this.type, this.breed, this.age, this.distance, this.lat, this.lng);
  static List<Pet> mock = [ //Demo data for pet
    Pet(1, "Cat", "Scottish Fold", 5, 200.0, 13.7025208, 100.5210237),
    Pet(2, "Dog", "Shiba Inu", 5, 69.0,13.5 ,100.5210237),
    Pet(3, "Hedgehog", "Sonic", 69, 4,13.7024947,100.5210237)
  ];
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