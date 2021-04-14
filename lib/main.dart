import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';

import 'package:istrayredux/globals.dart' as globals;
import 'Pet.dart';
import 'maps.dart';
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
  int _selectedIndex = 0;
  Position pos;
  List<Widget> _children = [PetContainer(pet: Pet.mock), MapScreen(), PetContainer(pet: [])];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    globals.updatePosition();
    pos = globals.getPosition();
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("iStray"),
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
