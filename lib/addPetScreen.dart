
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
                      'date': DateTime.now()
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormBuilderImagePicker(
                          name: "photo",
                          decoration: InputDecoration(
                              labelText: "Pet photo"),
                          maxImages: 1,
                        ),
                        FormBuilderTextField(
                          name: "type",
                          decoration: InputDecoration(
                              labelText: "Pet type"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          name: "breed",
                          decoration: InputDecoration(
                              labelText: "Pet breed"),
                        ),
                        FormBuilderTextField(
                          name: "size",
                          decoration: InputDecoration(
                              labelText: "Pet size"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderTextField(
                          name: "condition",
                          decoration: InputDecoration(
                              labelText: "Pet condition"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderDateTimePicker(
                          name: "date",
                          decoration: InputDecoration(
                              labelText: "Time found"),
                          validator: FormBuilderValidators.required(context),
                        ),
                        FormBuilderDropdown(
                            name: 'gender',
                            hint: Text('Pet gender'),
                            items: _gender.map((gender) =>
                                DropdownMenuItem(
                                  child: Text('$gender'),
                                  value: gender,)).toList()
                        ),
                        FormBuilderTextField(
                            name: 'remark',
                            decoration: InputDecoration(
                                labelText: "Remark")
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: TextButton(
                            onPressed: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                List<File> listfile = List<File>.from(_formKey.currentState!.value['photo']);
                                FirebaseStorage fsInstance = FirebaseStorage.instance;
                                late Reference ref;
                                try {
                                  ref = fsInstance.ref('pet/' + DateTime.now().millisecondsSinceEpoch.toString());
                                  await ref.putFile(listfile.first);
                                } on FirebaseException {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't upload file")));
                                }
                                String url = await ref.getDownloadURL();
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
                                    url,
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
