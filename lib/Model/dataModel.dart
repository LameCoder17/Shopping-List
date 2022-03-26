import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataModel {
  String name;
  String quantity;
  String id;


  FirebaseDataModel({
        required this.name,
        required this.quantity,
        required this.id
      });

  factory FirebaseDataModel.fromMap(QueryDocumentSnapshot snapshot) {
    return FirebaseDataModel(
      name: snapshot["name"],
      quantity: snapshot["quantity"],
      id: snapshot.id
      );
  }
}