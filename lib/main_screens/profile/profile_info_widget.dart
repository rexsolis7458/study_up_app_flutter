// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:study_up_app/controller/userController.dart';
// import 'package:study_up_app/helper/const.dart';
// import 'package:study_up_app/models/users.dart';

// import 'profile_tab.dart';

// class ProfileInfoWidget extends StatefulWidget {
//   UserController userController = Get.put(UserController());
//   late final UserModel users;

//   @override
//   _ProfileInfoWidgetState createState() => _ProfileInfoWidgetState();
// }

// class _ProfileInfoWidgetState extends State<ProfileInfoWidget> {
//   var _displayFNameController = TextEditingController();
//   var _displayLNameController = TextEditingController();
//   var _newemailController = TextEditingController();
//   var _newpasswordController = TextEditingController();

//   bool _nameValid = true;
//   bool _emailValid = true;

//   @override
//   void initState() {
//     _displayFNameController.text = widget.users.fname!;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _displayFNameController.dispose();
//     _displayLNameController.dispose();
//     _newemailController.dispose();
//     _newpasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
