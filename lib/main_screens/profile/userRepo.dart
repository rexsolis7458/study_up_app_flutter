import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/users.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection('users').where('email', isEqualTo: email).get;
    //  final userData =  UserModel.fromDocumentSnapshot();
    final userData = UserModel.fromDocumentSnapshot();
    // final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  // Future<List<UserModel>> allUsers() async {
  //   final snapshot = await _db.collection('users').get();
  //   final userData = UserModel.fromDocumentSnapshot().toList();
  //   return userData;
  // }

  updateUserRecords(UserModel user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .update(user.toMap());
  }
}
