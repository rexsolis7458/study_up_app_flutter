import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/models/users.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'profile_tab.dart';

class EditProfileTab extends StatefulWidget {
  UserController userController = Get.put(UserController());

  EditProfileTab({Key? key}) : super(key: key);

  @override
  _EditProfileTabState createState() => _EditProfileTabState();
}

class _EditProfileTabState extends State<EditProfileTab> {
  var _fnameController = TextEditingController();
  bool _fnameValid = true;
  bool _lnameValid = true;
  bool _newemailValid = true;
  bool _newpassValid = true;

  UserModel userModel = UserModel();

  late File pickedFile;
  ImagePicker imagePicker = ImagePicker();
  String imgUrl = '';

  // @override
  // void initState() {
  //   _displayNameController.text = widget.currentUserId.displayName;
  //   super.initState();
  // }

// updateProfileData(){
// setState(() {
//   if (_fnameValid || _lnameValid  || _newemailValid || _newpassValid){
//     FirebaseFirestore usersRef.document(widget.userId).updateData({
//       'fname':UserController.text,
//       'newemailValid':UserController.text,
//     });
//   }
// });
// }

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

  Widget firstnameTextField() {
    return TextFormField(
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
        // controller: _displayNameController;
      ),
    );
  }

  Widget lastnameTextField() {
    return TextFormField(
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
          // Positioned(
          //   top: 0.1,
          //   right: 150,
          //   child: Container(
          //     child: Padding(
          //       padding: EdgeInsets.all(1),
          //       child: InkWell(
          //         onTap: () {
          //           showModalBottomSheet(
          //             context: context,
          //             builder: ((builder) => bottomSheet()),
          //           );
          //         },
          //         child: Icon(
          //           Icons.add_a_photo,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //     decoration: BoxDecoration(
          //         border: Border.all(
          //           width: 3,
          //           color: Colors.white,
          //         ),
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(
          //             50,
          //           ),
          //         ),
          //         color: Colors.white,
          //         boxShadow: [
          //           BoxShadow(
          //             offset: Offset(2, 4),
          //             color: Colors.black.withOpacity(
          //               0.3,
          //             ),
          //             blurRadius: 3,
          //           ),
          //         ]),
          //   ),
          // ),
        ],
      ),
    );
  }

  // void _showModalSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (builder) {
  //         return new Container(
  //           height: 200.0,
  //           color: Colors.green,
  //           child: new Center(
  //             child: new Text(" Modal BottomSheet",
  //                 textScaleFactor: 2,
  //                 style: TextStyle(
  //                     color: Colors.white, fontWeight: FontWeight.bold)),
  //           ),
  //         );
  //       });
  // }

  Widget bottomSheet() {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose Profile Photo',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: Icon(Icons.camera),
                    onPressed: () => {
                      ImagePicker().pickImage(source: ImageSource.camera),
                    },
                    label: Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.image),
                    onPressed: () => {
                      getPhoto(ImageSource.gallery),
                      sendProfilePicData(),
                      Navigator.of(context).pop(),
                    },
                    label: Text('Gallery'),
                  ),
                ])
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: ButtonColor,
              ),
              onPressed: () {
                // var displayFName = _displayFNameController.text;
                // locator.get<UserController>().updateDisplayName(displayFName);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileTab()));
              },
              child: Text('Done'),
            )
          ],
          // leading: Builder(builder: (context) {
          //   return InkWell(
          //       // child: Container(
          //       //   child: Text("Cancel"),
          //       // ),
          //       // onTap: () {
          //       //   ProfileTab();
          //       //   Navigator.pushReplacement(context,
          //       //       MaterialPageRoute(builder: (context) => ProfileTab()));
          //       // },
          //       );
          // }),
          // title: Row(children: <Widget>[
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       primary: ButtonColor,
          //     ),
          //     onPressed: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => ProfileTab()));
          //     },
          //     child: Text('Cancel'),
          //   ),
          //   // SizedBox(
          //   //   width: 110,
          //   // ),
          //   Center(
          //     child: Text('Edit Profile'),
          //   ),
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       primary: ButtonColor,
          //     ),
          //     onPressed: () {
          //       // var displayFName = _displayFNameController.text;
          //       // locator.get<UserController>().updateDisplayName(displayFName);
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => ProfileTab()));
          //     },
          //     child: Text('Done'),
          //   ),
          // ]),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(children: <Widget>[
            imageProfile(),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: ButtonColor,
              ),
              onPressed: () async {
                showModalBottomSheet(
                    context: context, builder: (context) => bottomSheet());
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
          ]),
        ));
  }
}
