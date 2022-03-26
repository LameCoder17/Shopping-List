import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/Services/Auth.dart';

class Database {
  static final _db = FirebaseFirestore.instance.collection(AuthenticationHelper().id);

  static Future<bool> addItem(Map<String, dynamic> item) async {
    await _db.add(item);
    return true;
  }

  static Future<bool> updateItem(String id, Map<String, dynamic> item) async {
    await _db.doc(id).update(item);
    return true;
  }

  static Future<bool> deleteItem(String id) async {
    await _db.doc(id).delete();
    return true;
  }
}