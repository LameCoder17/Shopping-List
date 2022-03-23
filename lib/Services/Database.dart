import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final _db = FirebaseFirestore.instance.collection('items');

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