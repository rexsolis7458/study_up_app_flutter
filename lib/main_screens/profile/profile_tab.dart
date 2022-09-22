import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';

class ProfileTab extends StatelessWidget {
  late File pickedFile;
  ImagePicker imagePicker = ImagePicker();
  String imgUrl = '';

  UserController userController = Get.put(UserController());

  ProfileTab({Key? key}) : super(key: key);

  Future<bool> getPhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 100);
      if (pickedImage != null) {
        pickedFile = File(pickedImage.path);
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String?> sendProfilePicData() async {
    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}${FirebaseAuth.instance.currentUser!.uid}.jpg';
      Reference reference =
          FirebaseStorage.instance.ref().child('Profile Image').child(fileName);
      UploadTask uploadTask = reference.putFile(pickedFile);
      await uploadTask.whenComplete(() async {
        imgUrl = await uploadTask.snapshot.ref.getDownloadURL();
      });
      return imgUrl;
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) =>
      GetX<UserController>(initState: (_) async {
        Get.find<UserController>().user =
            await Database().getUser(Get.find<AuthController>().reference.id);
      }, builder: (_) {
        if (_.user.id != null) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: Drawer(
                child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: MainColor,
                  ),
                  child: CircleAvatar(
                    backgroundColor: MainColor,
                    child: SizedBox(
                      width: 100,
                      height: 95,
                      child: ClipOval(
                        child: Image.asset("assets/logo.png"),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                ListTile(
                  title: const Text('About Us'),
                  leading: const Icon(Icons.info_rounded),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Help'),
                  leading: Icon(Icons.help),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Sign out'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    AuthController.instance.logOut();
                  },
                ),
              ],
            )),
            appBar: AppBar(
              backgroundColor: MainColor,
              title: const Text('Profile'),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey,
                        child: ClipOval(
                          child: Image.asset('assets/logo.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.1,
                      right: 150,
                      child: Container(
                        child: InkWell(
                          onTap: () async {
                            getPhoto(ImageSource.gallery);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(2, 4),
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3,
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Name: ${_.user.fname} ${_.user.lname}'),
                const SizedBox(
                  height: 5,
                ),
                Text('Email: ${_.user.email}'),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.lock_open,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('REVEALS LEFT'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.person,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('REPUTATION'),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                  child: Container(
                    height: 50,
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.message),
                        SizedBox(
                          width: 32,
                        ),
                        Text(
                          'Create Group',
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                  child: Container(
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.file_copy,
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        Text(
                          'My Documents',
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 140,
                        ),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                  child: Container(
                    height: 50,
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.message),
                        SizedBox(
                          width: 32,
                        ),
                        Text(
                          'My Questions',
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  child: Text("Save!"),
                  onTap: () async {
                    _.user.profPic = await Get.put(sendProfilePicData());
                    userController.saveProfileData(_.user);
                  },
                )
              ],
            ),
          );
        } else {
          return const Text(
            'loading.....',
            textAlign: TextAlign.center,
          );
        }
      });
}
