

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addUser(String fname, String lname, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? id = auth.currentUser?.uid.toString();
  users.add({
    'Id': id,
    'First Name': fname,
    'Last Name': lname,
    'Email': email,
  });
  return;
}