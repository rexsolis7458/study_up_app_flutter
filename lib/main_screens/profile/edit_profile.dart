import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/profile/userRepo.dart';
import 'package:study_up_app/models/users.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:study_up_app/services/database.dart';

import 'profile_tab.dart';

class EditProfileTab extends StatefulWidget {
  UserController userController = Get.put(UserController());

  EditProfileTab({Key? key}) : super(key: key);

  @override
  _EditProfileTabState createState() => _EditProfileTabState();
}

class _EditProfileTabState extends State<EditProfileTab> {
  Database database = Database();

  bool _fnameValid = true;
  bool _lnameValid = true;
  bool _newemailValid = true;
  bool _newpassValid = true;

  late String _imagePickedType;
  // late File _profileImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  UserModel userModel = UserModel();

  UserRepository userRepository = UserRepository();

  AuthController authController = AuthController();

  // late File pickedFile;
  ImagePicker imagePicker = ImagePicker();
  String imgUrl = '';

  get currentUser => null;

  firstnameTextField() {
    return TextFormField(
      initialValue: userModel.firstname,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: ButtonColor,
        ),
        labelText: 'First Name',
        // helperText: "Name can't be empty",
        hintText: 'First Name',
      ),
    );
  }

  Widget lastnameTextField() {
    return TextFormField(
      initialValue: userModel.lastname,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromARGB(255, 54, 35, 34),
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: ButtonColor,
        ),
        labelText: 'Last Name',
        hintText: 'Last Name',
        // controller: _displayNameController;
      ),
    );
  }

  Widget newemailTextField() {
    return TextFormField(
      initialValue: userModel.email,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: ButtonColor,
        ),
        labelText: 'Email',
        hintText: 'New Email',
      ),
    );
  }

  Widget newpassTextField() {
    return TextFormField(
      initialValue: userModel.firstname,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: ButtonColor,
        ),
        labelText: 'Password',
        hintText: 'New Paswword',
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget bottomSheet() {
  //   return Container(
  //     height: 200.0,
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.symmetric(),
  //     child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             'Choose Profile Photo',
  //             style: TextStyle(
  //               fontSize: 20.0,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: <Widget>[
  //                 ElevatedButton.icon(
  //                   icon: Icon(Icons.camera),
  //                   onPressed: () => {
  //                     ImagePicker().pickImage(source: ImageSource.camera),
  //                   },
  //                   label: Text('Camera'),
  //                 ),
  //                 ElevatedButton.icon(
  //                   icon: Icon(Icons.image),
  //                   onPressed: () => {
  //                     _imagePickedType = 'profile',
  //                     handleImageFromGallery(),
  //                     Navigator.of(context).pop(),
  //                   },
  //                   label: Text('Gallery'),
  //                 ),
  //               ])
  //         ]),
  //   );
  // }

  // handleImageFromGallery() async {
  //   try {
  //     final imageFile =
  //         await ImagePicker().getImage(source: ImageSource.gallery);
  //     if (imageFile != null) {
  //       if (_imagePickedType == 'profile') {
  //         setState(() {
  //           _profileImage = imageFile as File;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _name = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          // actions: [
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       primary: ButtonColor,
          //     ),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ProfileTab(),
          //         ),
          //       );
          //     },
          //     child: Text('Done'),
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: FutureBuilder(
                future: authController.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      UserModel user = snapshot.data as UserModel;

                      var _newFNameController =
                          TextEditingController(text: user.firstname);
                      var _newLNameController =
                          TextEditingController(text: user.lastname);
                      var _newPasswordController =
                          TextEditingController(text: user.password);
                      var _newEmailController =
                          TextEditingController(text: user.email);

                      return Column(
                        children: [
                          ListView(
                            children: <Widget>[
                              Form(
                                child: Column(
                                  children: <Widget>[
                                    imageProfile(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: ButtonColor,
                                      ),
                                      onPressed: () async {
                                        // showModalBottomSheet(
                                        //     context: context,
                                        //     builder: (context) => bottomSheet());
                                      },
                                      child: Text('Edit Profile Photo'),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    firstnameTextField(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    lastnameTextField(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    newemailTextField(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    newpassTextField(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Container(),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final userData = UserModel(
                                          email:
                                              _newEmailController.text.trim(),
                                          password: _newPasswordController.text
                                              .trim(),
                                          firstname:
                                              _newFNameController.text.trim(),
                                          lastname:
                                              _newLNameController.text.trim(),
                                        );
                                        await authController.updateRecord(user);
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: ButtonColor),
                                        child: const Center(
                                          child: Text(
                                            "Edit Profile",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ));
  }
}
