// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:istrayredux/addPetScreen.dart';
import 'package:istrayredux/dataRepository.dart';
import 'package:mockito/mockito.dart';

import 'mockfirebase.dart';
import 'package:istrayredux/main.dart';
import 'package:istrayredux/globals.dart' as globals;
import 'package:istrayredux/models/Pet.dart';
import 'package:istrayredux/petContainer.dart';
import 'package:istrayredux/maps.dart';

void main() {
  setupFirebaseAuthMocks();
  final firestore = MockFirestoreInstance();
  final user = MockUser(
    isAnonymous: true,
    uid: "1",
  );
  globals.user = user;
  globals.repository = DataRepository.withInstance(firestore);
  Pet cat = Pet("Cat", "10 inch", "Good", Timestamp.now(), GeoPoint(0,0), "1");
  Pet dog = Pet("Dog", "10 inch", "Bad", Timestamp.now(), GeoPoint(1,1), "2");
  setUpAll(() async {
    await Firebase.initializeApp();
    await firestore.collection('pets').add(cat.toJson());
    await firestore.collection('pets').add(dog.toJson());
  });
  testWidgets('shouldn\'t see dog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: testPetContainer()));
    await tester.idle();
    await tester.pump();
    final noDog = find.text("Dog");
    expect(noDog, findsNothing);
  });
  testWidgets('add pet', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(720, 1280);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MaterialApp(home: AddPetScreen()));
    await tester.enterText(find.byKey(Key('type')), "Cat");
    await tester.enterText(find.byKey(Key('breed')), "Scottish Fold");
    await tester.enterText(find.byKey(Key('size')), "12 inch");
    await tester.enterText(find.byKey(Key('condition')), "Hungry");
    await tester.enterText(find.byKey(Key('remark')), "Lulu");
    globals.pos = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0, isMocked: true);
    await tester.pump();
    //await tester.ensureVisible(find.byType(TextButton));
    await tester.tap(find.byKey(Key("submit button")));
    await tester.pump(Duration(seconds: 1));
    QuerySnapshot x = await firestore.collection('pets').get();
    expect(x.docs.length, 3);
  });
}
class testPetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PetContainer(false),
    );
  }
}