import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/Services/Auth.dart';

class Database {
  static Future<bool> addItem(Map<String, dynamic> item) async {
    await FirebaseFirestore.instance.collection(AuthenticationHelper().id).add(item);
    return true;
  }

  static Future<bool> updateItem(String id, Map<String, dynamic> item) async {
    await FirebaseFirestore.instance.collection(AuthenticationHelper().id).doc(id).update(item);
    return true;
  }

  static Future<bool> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection(AuthenticationHelper().id).doc(id).delete();
    return true;
  }
}