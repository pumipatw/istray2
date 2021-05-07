import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:istrayredux/addPetScreen.dart';
import 'package:istrayredux/editPetScreen.dart';

import 'package:istrayredux/globals.dart' as globals;
import 'package:istrayredux/petContainer.dart';
import 'package:istrayredux/maps.dart';
import 'package:istrayredux/petPage.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(iStrayApp());
}

// ignore: camel_case_types
class iStrayApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        PetPage.route: (context) => PetPage(),
        AddPetScreen.route: (context) => AddPetScreen(),
        EditPetScreen.route: (context) => EditPetScreen()
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
  Home({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Position? pos;
  User? user;
  List<Widget> _children = [PetContainer(true), MapScreen(), PetContainer(false)];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  var location;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    globals.updatePosition();
    pos = globals.getPosition();
    _anonSignIn();
    location = Permission.unknown;
  }
  void _checkStatus(PermissionStatus status) {
    if(location != status) {
      setState(() {
        location = status;
      });
    }
  }
  void _anonSignIn() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    globals.user = userCredential.user;
  }
  void retry() {
    openAppSettings();
    setState(() {
    });
  }
    @override
  Widget build(BuildContext context) {
          if(location == PermissionStatus.denied) {
            return Scaffold(
              appBar: AppBar(title: Text("iStray"),),
              body: Center(
                child: Column(
                  children:[
                    Text("This application needed location permission to function"),
                    SizedBox(
                      width: 15,
                      height: 15,
                    ),
                    ColoredBox(
                      color: Colors.green,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: TextButton(
                          child: Text("Grant Permission", style: TextStyle(color: Colors.white),),
                          onPressed: () {Permission.location.request().then((permission) => _checkStatus(permission));},
                        ),
                      ),
                    )
                  ]
                ),
              ),
            );
          }
          else if(location == PermissionStatus.permanentlyDenied) {
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      Text("Permission is permanently denied, open your device settings to turn on"),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextButton(
                          child: Text("Open Settings"),
                          onPressed: retry,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          return Scaffold(
            appBar: AppBar(
              title: Text("iStray", style: TextStyle(color: Colors.white),),
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
            floatingActionButton: _selectedIndex != 1 ? FloatingActionButton(
              foregroundColor: Colors.white,
              child: Icon(FontAwesomeIcons.plus),
              tooltip: "Report new pet",
              onPressed: () async {
                var status = await Permission.storage.status;
                if(status.isDenied) {
                  Permission.storage.request();
                }
                Navigator.pushNamed(context, AddPetScreen.route);
              },
            ) : null,
          );
        }
}

