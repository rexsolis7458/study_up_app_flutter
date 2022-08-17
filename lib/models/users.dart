

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel
{

  String? id;
  String? fname;
  String? lname;
  String? email;
  String? password;

  UserModel({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.password,
  });

  UserModel.fromSnapshot(DocumentSnapshot<Map<String?, dynamic>> doc)
  {
    id = doc.id;
    fname = doc.data()!["first name"];
    lname = doc.data()!["last name"];
    email = doc.data()!["email"];
  }
}