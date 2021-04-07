import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'Pet.dart';

void main() {
  runApp(iStrayApp());
}

// ignore: camel_case_types
class iStrayApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/detail": (context) => PetPage()
      },
      title: 'iStray',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Home(title: 'iStray'),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Pet> pet = [ //Demo data for pet
    Pet(1, "Cat", "Scottish Fold", 5, 200.0),
    Pet(2, "Dog", "Shiba Inu", 5, 69.0),
    Pet(3, "Hedgehog", "Sonic", 69, 420.0)
  ];
  static List<Pet> petMock2 = [ //Demo data for pet
    Pet(1, "Frog", "Fold", 5, 200.0),
    Pet(2, "Mario", "Plumber", 5, 69.0),
    Pet(3, "Kirby", "Pink Puffball", 69, 420.0),
    Pet(4, "Fox", "Fox", 555, 555.0)
  ];
  int _selectedIndex = 0;
  List<Widget> _children = [PetContainer(pet: pet), Container(color: Colors.red,), PetContainer(pet: petMock2)];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(FontAwesome.map_marker),
          label: "Nearby"),
          BottomNavigationBarItem(icon: Icon(FontAwesome.map),
          label: "Maps"),
          BottomNavigationBarItem(icon: Icon(FontAwesome.history),
          label: "History")
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
