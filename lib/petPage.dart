import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/Pet.dart';

class PetPage extends StatelessWidget {
  static final String route = "/detail";
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Pet;
    print(args);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                  child:
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                          children: [
                            Text(args.type!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                            if(args.breed != null) Text(args.type! + " breed: " + args.breed!),
                            Text("Size: " + args.size!),
                            Text("Condition: " + args.condition!),
                            Text("Date last found: " + DateFormat('d MMM yyyy h:mm').format(args.date!.toDate().toLocal())),
                            if(args.gender != null) Text("Gender: " + args.gender!),
                            if(args.remark != null) Text("Remark: " + args.remark!)
                          ],
                        ),],
                      )
                  ),
                  Expanded(child: Hero(tag: 'pet', child: (args.pictureUrl != null) ? Image.network(args.pictureUrl!) : Image.asset('images/icon/icon.png')))
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}