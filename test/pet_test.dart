import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:istrayredux/models/Pet.dart';

void main() {
  test('Create pet', () {
    Timestamp test = Timestamp.now();
    final Pet p = Pet("Cat", "6 inch", "Good", test, GeoPoint(0, 0), "69");
    expect(p.type, "Cat");
    expect(p.size, "6 inch");
    expect(p.condition, "Good");
    expect(p.date, test);
  });
}