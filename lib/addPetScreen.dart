
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:geolocator/geolocator.dart';

import 'models/Pet.dart';
import 'globals.dart' as globals;

class AddPetScreen extends StatelessWidget {
  static final String route = "/add";
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Report New Pet")),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'date': DateTime.now(),
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormBuilderImagePicker(
                          key: Key('photo'),
                          name: "photo",
                          decoration: InputDecoration(
                              labelText: "Pet photo"),
                          maxImages: 1,
                        ),
                        FormBuilderTextField(
                          key: Key('type'),
                          name: "type",
                          decoration: InputDecoration(
                              labelText: "Pet type"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          key: Key('breed'),
                          name: "breed",
                          decoration: InputDecoration(
                              labelText: "Pet breed"),
                        ),
                        FormBuilderTextField(
                          key: Key('size'),
                          name: "size",
                          decoration: InputDecoration(
                              labelText: "Pet size"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          key: Key('condition'),
                          name: "condition",
                          decoration: InputDecoration(
                              labelText: "Pet condition"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderDateTimePicker(
                          key: Key('date'),
                          name: "date",
                          decoration: InputDecoration(
                              labelText: "Time found"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderDropdown(
                            key: Key('gender'),
                            name: 'gender',
                            hint: Text('Pet gender'),
                            items: _gender.map((gender) =>
                                DropdownMenuItem(
                                  child: Text('$gender'),
                                  value: gender,)).toList()
                        ),
                        FormBuilderTextField(
                            key: Key('remark'),
                            name: 'remark',
                            decoration: InputDecoration(
                                labelText: "Remark")
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          key: Key("submit button"),
                          width: 100,
                          height: 50,
                          child: TextButton(
                            onPressed: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                List<File> listfile = List<File>.from(_formKey.currentState!.value['photo'] != null ? _formKey.currentState!.value['photo'] : []);
                                late Reference ref;
                                String url = "";
                                if(listfile.isNotEmpty) {
                                  try {
                                    FirebaseStorage fsInstance = FirebaseStorage.instance;
                                    ref = fsInstance.ref('pet/' + DateTime.now().millisecondsSinceEpoch.toString());
                                    await ref.putFile(listfile.first);
    url = await                     ref.getDownloadURL();
                                  } on FirebaseException {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't upload file")));
                                  }
                                }
                                Position? _x = globals.getPosition();
                                GeoPoint _y = globals.positionToGeoPoint(_x!);
                                Pet submit = Pet(
                                    _formKey.currentState!.value['type'],
                                    _formKey.currentState!.value['size'],
                                    _formKey.currentState!.value['condition'],
                                    Timestamp.fromDate(
                                        _formKey.currentState!.value['date']),
                                    _y,
                                    globals.user!.uid,
                                    pictureUrl: url,
                                    breed: _formKey.currentState!
                                        .value['breed'],
                                    gender: _formKey.currentState!
                                        .value['gender'],
                                    remark: _formKey.currentState!
                                        .value['remark']
                                );
                                globals.repository.addPet(submit);
                                Navigator.pop(context);
                              }
                            },
                            child: Text("SUBMIT"),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700
                              ),
                                backgroundColor: Colors.lightGreen,
                                primary: Colors.white),
                          ),
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}
List<String> _gender = [
  "Male",
  "Female",
  "Other"
];
