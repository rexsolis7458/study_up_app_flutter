

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel
{
  late String? id;
  late String? fname;
  late String? lname;
  late String? email;
  late String? password;
  late String? profPic;

  UserModel({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.password,
    this.profPic,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot? doc})
  {
    id = doc!.get('id');
    fname = doc.data().toString().contains('fname') ? doc.get('fname') : '';
    lname = doc.data().toString().contains("lname") ? doc.get('lname') : '';
    email = doc.data().toString().contains('email') ? doc.get('email') : '';
    password = doc.data().toString().contains('password') ? doc.get('password') : '';
    profPic = doc.data().toString().contains('profPic') ? doc.get('profPic') : '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'password': password,
      'profPic' : profPic,
    };
  }
}