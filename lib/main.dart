import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:istrayredux/globals.dart' as globals;
import 'package:istrayredux/petContainer.dart';
import 'Pet.dart';
import 'maps.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  List<Widget> _children = [PetContainer(), MapScreen(), PetContainer()];
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
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.mapMarker),
          label: "Nearby"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.mapMarkedAlt),
          label: "Maps"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.history),
          label: "History")
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
