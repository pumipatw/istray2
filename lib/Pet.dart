import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  String type;
  String breed;
  String size;
  String gender;
  String condition;
  String remark;
  Timestamp date;

  DocumentReference reference;

  Pet(this.type, this.size, this.condition, this.date, { this.breed, this.gender, this.remark});

  factory Pet.fromSnapshot(DocumentSnapshot snapshot) {
    Pet newPet = Pet.fromJson(snapshot.data());
    newPet.reference = snapshot.reference;
    return newPet;
  }

  factory Pet.fromJson(Map<dynamic, dynamic> json) => _petFromJson(json);

  Map<String, dynamic> toJson() => _petToJson(this);

  @override
  String toString() => "Pet<$type, $date>";
}
Pet _petFromJson(Map<dynamic, dynamic> json) {
  return Pet(
    json['type'] as String,
    json['size'] as String,
    json['condition'] as String,
    json['date'] as Timestamp,
    breed: json['breed'] == null ? null : json['breed'] as String,
    gender: json['gender'] == null ? null : json['gender'] as String,
    remark: json['remark'] == null ? null : json['remark'] as String
  );
}
Map<String, dynamic> _petToJson(Pet instance) =>
  <String, dynamic> {
    'type': instance.type,
    'size': instance.size,
    'condition': instance.condition,
    'date': instance.date,
    'breed': instance.breed,
    'gender': instance.gender,
    'remark': instance.remark
  };
