// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../models/users.dart';
// import '../../services/database.dart';


// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstnameController = TextEditingController();
//   final _lastnameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   UserModel _userModel = UserModel();

//   @override
//   void initState() {
//     super.initState();
//     _userModel = UserModel(
//       firstname: FirebaseAuth.instance.currentUser?.firstname,
//       lastname: FirebaseAuth.instance.currentUser.lastname,
//       email: FirebaseAuth.instance.currentUser?.email,
//       password: FirebaseAuth.instance.currentUser.password,
      
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               TextFormField(
//                 controller: _firstnameController,
//                 decoration: InputDecoration(labelText: 'First Name'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your first name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _lastnameController,
//                 decoration: InputDecoration(labelText: 'Last Name'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your last name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your phone email';
//                   }
//                   return null;
//                 },
//               ),
//                TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your phone password';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               Center(
//                 child: TextButton(
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       _userModel.firstname = _firstnameController.text;
//                        _userModel.lastname = _lastnameController.text;
//                       _userModel.email = _emailController.text;
//                       _userModel.password = _passwordController.text;
//                       await Database()
//                           .updateUserProfile(_userModel, FirebaseAuth.instance.currentUser);
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Text('Save'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }