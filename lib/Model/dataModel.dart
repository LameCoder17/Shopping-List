import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataModel {
  String createdBy;
  String name;
  String quantity;
  String id;


  FirebaseDataModel({
        required this.createdBy,
        required this.name,
        required this.quantity,
        required this.id
      });

  factory FirebaseDataModel.fromMap(QueryDocumentSnapshot snapshot) {
    return FirebaseDataModel(
      createdBy: snapshot["createdBy"],
      name: snapshot["name"],
      quantity: snapshot["quantity"],
      id: snapshot.id
      );
  }
}