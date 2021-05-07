import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:istrayredux/globals.dart' as globals;
import 'package:geolocator/geolocator.dart' as geolocator;

class Pet {
  String type;
  String? breed;
  String size;
  String? gender;
  String condition;
  String? remark;
  String? userId;
  String? pictureUrl;
  Timestamp date;
  GeoPoint location;
  late double distance;

  late DocumentReference reference;

  Pet(this.type, this.size, this.condition, this.date, this.location, this.userId, {this.pictureUrl, this.breed, this.gender, this.remark});

  factory Pet.fromSnapshot(DocumentSnapshot snapshot) {
    Pet newPet = Pet.fromJson(snapshot.data()!);
    newPet.reference = snapshot.reference;
    return newPet;
  }

  factory Pet.fromJson(Map<dynamic, dynamic> json) => _petFromJson(json);

  Map<String, dynamic> toJson() => _petToJson(this);
  void calculateDistance(geolocator.Position n) {
    distance = geolocator.Geolocator.distanceBetween(location.latitude, location.longitude, n.latitude, n.longitude);
  }
  @override
  String toString() => "Pet<$type, $size, $condition, $date, ${location.toString()}>";
}
Pet _petFromJson(Map<dynamic, dynamic> json) {
  return Pet(
    json['type'] as String,
    json['size'] as String,
    json['condition'] as String,
    json['date'] as Timestamp,
    json['location'] as GeoPoint,
    json['userid'] as String?,
    pictureUrl: json['pictureUrl'] == null ? null : json['pictureUrl'] as String?,
    breed: json['breed'] == null ? null : json['breed'] as String?,
    gender: json['gender'] == null ? null : json['gender'] as String?,
    remark: json['remark'] == null ? null : json['remark'] as String?
  );
}
Map<String, dynamic> _petToJson(Pet instance) =>
  <String, dynamic> {
    'type': instance.type,
    'size': instance.size,
    'condition': instance.condition,
    'date': instance.date,
    'location': instance.location,
    'userid': instance.userId,
    'pictureUrl': instance.pictureUrl,
    'breed': instance.breed,
    'gender': instance.gender,
    'remark': instance.remark
  };