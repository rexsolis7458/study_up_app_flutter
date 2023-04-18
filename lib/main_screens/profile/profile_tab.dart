import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/profile/favScreen.dart';
import 'package:study_up_app/main_screens/profile/myFavoriteQuizzes.dart';
import 'package:study_up_app/main_screens/profile/myQuestions.dart';
import 'package:study_up_app/main_screens/profile/userFiles.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';
import 'edit_profile.dart';
import 'editprofileSample.dart';

class ProfileTab extends StatelessWidget {
  final storage = FirebaseStorage.instance;
  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();
  String imgUrl = '';

  UserController userController = Get.put(UserController());

  ProfileTab({Key? key}) : super(key: key);

  Future<void> getCurrentUser() async {
    // Get the current user's uid
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    // Get the current user's groups
    final groupsSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContains: userId)
        .get();

    // Loop through all the groups the user is a member of
    for (var group in groupsSnapshot.docs) {
      final groupId = group.id;

      // Get the current user's file count for this group
      final fileCount =
          await getUserFileCount(groupId: groupId, userId: userId);

      // Do something with the file count
      print('User $userId has $fileCount files in group $groupId');
    }
  }

  Future<int> getUserFileCount(
      {required String groupId, required String userId}) async {
    // Set the path to the PDF files directory for the current user and group
    final userFilesRef = storage.ref().child('Pdf files/$groupId/$userId');

    // Get a list of all the files in the user's directory
    final files = await userFilesRef.listAll();

    // Return the number of files in the directory
    return files.items.length;
  }

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
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<String?> sendProfilePicData() async {
    if (pickedFile == null) {
      return null;
    }
    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}${FirebaseAuth.instance.currentUser!.uid}.jpg';
      Reference reference =
          FirebaseStorage.instance.ref().child('Profile Image').child(fileName);
      UploadTask uploadTask = reference.putFile(pickedFile!);
      await uploadTask.whenComplete(() async {
        imgUrl = await uploadTask.snapshot.ref.getDownloadURL();
      });
      return imgUrl;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
        print('Error uploading profile picture: $e');
      }
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
                          child: Image.network(
                            _.user.profilePicture ??
                                "https://example.com/default_profile_picture.png",
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.cover),
                          ),
                        )),
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
                            child: Image.network(
                              _.user.profilePicture ??
                                  "https://example.com/default_profile_picture.png",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                  "assets/logo.png",
                                  fit: BoxFit.cover),
                            ),
                          )),
                    ),
                    Positioned(
                      top: 0.1,
                      right: 146,
                      child: Container(
                        // ignore: sort_child_properties_last
                        child: InkWell(
                          onTap: () async {
                            final didGetPhoto =
                                await getPhoto(ImageSource.gallery);
                            if (didGetPhoto) {
                              // Show alert dialog
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Save as profile picture?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                ),
                              ).then((result) async {
                                if (result == true) {
                                  // User chose to save as profile picture
                                  String? profilePic =
                                      await sendProfilePicData();
                                  if (profilePic != null) {
                                    _.user.profilePicture = profilePic;
                                    userController.saveProfileData(_.user);
                                  } else {
                                    Get.snackbar("Error",
                                        "Failed to save profile picture.");
                                  }
                                  userController.saveProfileData(_.user);
                                } else {
                                  // User chose not to save as profile picture
                                }
                              });
                            }
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
                TextButton(
                  style: TextButton.styleFrom(
                    primary: ButtonColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(user: UserModel())));
                  },
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('${_.user.firstname} ${_.user.lastname}'),
                const SizedBox(
                  height: 5,
                ),
                Text('${_.user.email}'),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoriteQuizzes(),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 10.0),
                    child: SizedBox(
                      height: 70,
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
                            'Flagged Quizzes',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            width: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserFiles(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 70, // set the height of the card
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10.0),
                      child: Container(
                        child: Row(
                          children: [
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
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserQuestion(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 70,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10.0),
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
                ),
                const Spacer(),
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
