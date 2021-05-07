import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'models/Pet.dart';
import 'editPetScreen.dart';
import 'globals.dart' as globals;

class PetPage extends StatelessWidget {
  static final String route = "/detail";
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Pet;
    final latlng = globals.geoPointToLatLng(args.location);
    print(args);
    StringBuffer text = StringBuffer();
    if(args.breed != null) text.write("${args.type} breed: " + args.breed! + '\n');
    text.write("Size: " + args.size + '\n');
    if(args.gender != null) text.write("${args.type} gender: " + args.gender! + '\n');
    text.write("Condition: " + args.condition + '\n');
    text.write("Time last found: " + DateFormat("HH:mm dd MMMM").format(args.date.toDate()) + '\n');
    if(args.remark != null) text.write("Remark: " + args.remark!);
    return Scaffold(
      appBar: AppBar(
        actions: [
          if(globals.user!.uid == args.userId) PopupMenuButton<String>(
            onSelected: (choice) => _handleClick(context, choice, args),
            itemBuilder: (BuildContext context) {
                return {'Edit', 'Delete'}.map((choice) {
                  return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice));
                }).toList();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4 - AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 3.0,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ListTile(
                          title: Text(args.type, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        ListTile(
                          title: Text(
                            text.toString()
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 5,
                      right: 1,
                      child: Visibility(
                        visible: args.pictureUrl != null,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Hero(
                              tag: '$args',
                              child: Image.network(args.pictureUrl!)
                        ),
                      ),
                    )
                    )
                  ]
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6 - AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width - 20,
              child: Card(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: latlng,
                      zoom: 16
                  ),
                  myLocationEnabled: true,
                  markers: {
                    Marker(
                        markerId: MarkerId('$args'),
                        position: latlng
                    )
                  },
                ),
              )
            ),
          ],
        )
      ),
    );
  }
  void _handleClick(BuildContext context, String choice, Pet args) {
    switch (choice) {
      case 'Edit':
        Navigator.pushNamed(context, EditPetScreen.route, arguments: args);
        break;
      case 'Delete':
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete pet"),
            content: Text("Are you sure to delete this pet?"),
            actions: [
              TextButton(
                  onPressed: () {
                    globals.repository.deletePet(args);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("May pet find its homw")));
                  },
                  child: Text("Yes")),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("No"),)
            ],
          );
        });
        break;
    }
  }
}
