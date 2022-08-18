

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_up_app/models/users.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "id": user.id,
        "fname": user.fname.toString(),
        "lname": user.lname.toString(),
        "email": user.email,
        // "password": user.password,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  
  Future<UserModel> getUser(String id) async 
  {
    try {
      DocumentSnapshot doc = 
          await _firestore.collection("users").doc(id).get();

      return UserModel.fromDocumentSnapshot(doc: doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}