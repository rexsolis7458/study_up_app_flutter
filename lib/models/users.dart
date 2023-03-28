import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String? id;
  late String? firstname;
  late String? lastname;
  late String? email;
  late String? password;
  late String? profilePicture;
  late String? birthday;
  late String? gender;

  UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.profilePicture,
    this.birthday,
    this.gender,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot? doc}) {
    id = doc!.get('id');
    firstname =
        doc.data().toString().contains('firstname') ? doc.get('firstname') : '';
    lastname =
        doc.data().toString().contains("lastname") ? doc.get('lastname') : '';
    email = doc.data().toString().contains('email') ? doc.get('email') : '';
    password =
        doc.data().toString().contains('password') ? doc.get('password') : '';
    profilePicture = doc.data().toString().contains('profilePicture')
        ? doc.get('profilePicture')
        : '';
    birthday =
        doc.data().toString().contains('birthday') ? doc.get('birthday') : '';
    gender = doc.data().toString().contains('gender') ? doc.get('gender') : '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'profilePicture': profilePicture,
      'birthday': birthday,
      'gender': gender,
    };
  }
}
