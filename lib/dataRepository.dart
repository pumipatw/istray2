import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './models/Pet.dart';

class DataRepository {
  late CollectionReference collection;
  DataRepository() {
    collection = FirebaseFirestore.instance.collection('pets');
  }
  DataRepository.withInstance(FirebaseFirestore instance) {
    collection = instance.collection('pets');
  }
  Stream<QuerySnapshot> getStream(User? user) {
    if(user != null) return collection.where('userid', isEqualTo: user.uid).snapshots();
    else return collection.snapshots();
  }
  Future<DocumentReference> addPet(Pet pet) {
    return collection.add(pet.toJson());
  }
  void updatePet(Pet pet) async {
    await collection.doc(pet.reference.id).update(pet.toJson());
  }
}