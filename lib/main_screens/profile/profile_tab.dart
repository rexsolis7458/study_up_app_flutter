import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/profile/favScreen.dart';
import 'package:study_up_app/main_screens/profile/group_request.dart';
import 'package:study_up_app/main_screens/profile/myQuestions.dart';
import 'package:study_up_app/main_screens/profile/profileModel.dart';
import 'package:study_up_app/main_screens/profile/userFiles.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';
import '../group/files/file_model.dart';
import 'edit_profile.dart';
import 'editprofileSample.dart';
import '../group/q&a/rateUser.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({Key? key}) : super(key: key);
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileModel profileModel = ProfileModel(
    rateID: randomAlphaNumeric(16),
    ratingValue: 0,
    value: '',
    average: 0,
  );

  final storage = FirebaseStorage.instance;
  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();
  String imgUrl = '';

  UserController userController = Get.put(UserController());

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

  Future<int> getUserFileCountForReputation(
      String groupId, String userId) async {
    final result = await FirebaseStorage.instance
        .ref()
        .child('Pdf files/$groupId/$userId')
        .list();
    return result.items.length;
  }

  String getUserId() {
    User? user = _auth.currentUser;
    return user?.uid ?? '';
  }

  Future<double> getProfileAverageRating(String id) async {
    String userId = getUserId();
    // ignore: non_constant_identifier_names
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collectionGroup('Ratings')
        .where('uploader', isEqualTo: userId)
        .orderBy('created')
        .get();

    List<double> rates = [];
    double filesTotal = 0;

    for (var doc in snapshot.docs) {
      double rate =
          double.parse((doc.data() as Map<String, dynamic>)['rating']);
      rates.add(rate);
    }
    for (int i = 0; i < rates.length; i++) {
      filesTotal += rates[i];
    }
    double filesAverage = filesTotal / rates.length;
    print('Total: $filesAverage');

    CollectionReference pLists =
        FirebaseFirestore.instance.collection('User Rating');
    QuerySnapshot querySnapshot =
        await pLists.doc(id).collection('Ratings').get();
    List<QueryDocumentSnapshot> pRatings = querySnapshot.docs;
    double profileSum = 0;
    double profileCount = 0;
    for (QueryDocumentSnapshot rating in pRatings) {
      double value = double.parse(rating['rating']);
      profileSum += value;
      profileCount++;
    }

    var profileAve = profileSum / profileCount;

    double userReputation = profileAve + filesAverage;

    return userReputation;
  }

  @override
  Widget build(BuildContext context) =>
      GetX<UserController>(initState: (_) async {
        Get.find<UserController>().user =
            await Database().getUser(Get.find<AuthController>().reference.id);
      }, builder: (_) {
        if (_.user.id != null) {
          String? userEmail = _.user.email;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: Drawer(
                child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: BGColor,
                  ),
                  child: SizedBox(
                    width: 90,
                    height: 60,
                    child: Image.asset("assets/StudyUp.png", fit: BoxFit.fill),
                  ),
                ),
                Container(
                  height: 30,
                ),
                ListTile(
                  title: const Text('About Us'),
                  leading: const Icon(Icons.info_rounded),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('About Us'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text(
                                'The Developers of the mobile applications are 4th year BSIT students major in Mobile Development of the University of San Jose Recoletos. '),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Help'),
                  leading: Icon(Icons.help),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Help'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. '),
                          ),
                        ],
                      ),
                    );
                  },
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
            body: SizedBox(
              height:
                  MediaQuery.of(context).size.height - kToolbarHeight - 30.0,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.network(
                                _.user.profilePicture ??
                                    "https://example.com/default_profile_picture.png",
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                    "assets/Logo.png",
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
                                    title:
                                        const Text('Save as profile picture?'),
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
                    height: 5,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: ButtonColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            user: UserModel(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${_.user.firstname} ${_.user.lastname}'),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${_.user.email}'),
                  const SizedBox(
                    height: 30,
                  ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  Card(
                      color: BGColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10.0),
                      child: SizedBox(
                        height: 70,
                        child: ListTile(
                          title: Text(
                            'Reputation',
                          ),
                          leading: const Icon(
                            Icons.diversity_3,
                            size: 32,
                          ),
                          trailing: FutureBuilder<double>(
                            future: getProfileAverageRating(userEmail!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Calculating rating...');
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final rating = snapshot.data!;
                                return Text(' ${rating.toStringAsFixed(2)}');
                              }
                            },
                          ),
                        ),
                      )),
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
                      color: BGColor,
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
                        color: BGColor,
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
                        color: BGColor,
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
                          builder: (context) => GroupRequestsPage(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 70,
                      child: Card(
                        color: BGColor,
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
                              'Group Request',
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
                  const Spacer(),
                ],
              ),
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

void _RateAlertDialog() async {
  AlertDialog(
    title: const Text('About Us'),
    actions: [
      TextButton(
        onPressed: () {},
        child: const Text(
            'The Developers of the mobile applications are 4th year BSIT students major in Mobile Development of the University of San Jose Recoletos. '),
      ),
    ],
  );
}

  // AlertDialog(
  //   title: const Text("Rate this File"),
  //   content: Container(
  //     child: RatingBar(
  //       initialRating: 0,
  //       direction: Axis.horizontal,
  //       allowHalfRating: true,
  //       itemCount: 5,
  //       ratingWidget: RatingWidget(
  //         full: const Icon(Icons.star, color: Colors.orange),
  //         half: const Icon(Icons.star_half, color: Colors.orange),
  //         empty: const Icon(Icons.star_outline, color: Colors.orange),
  //       ),
  //       onRatingUpdate: (value) {
  //         // setState(() {
  //         //   fileModel.ratingValue = value;
  //         //   print(fileModel.ratingValue);
  //         // },
  //         // );
  //       },
  //     ),
  //   ),
  //   actions: <Widget>[
  //     Column(
  //       children: <Widget>[
  //         Center(
  //             // child: Text(
  //             //   fileModel.ratingValue != null
  //             //       ? fileModel.ratingValue.toString()
  //             //       : 'Rate it!',
  //             //   style: const TextStyle(color: Colors.black, fontSize: 25),
  //             // ),
  //             ),
  //       ],
  //     ),
  //     Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         TextButton(
  //           onPressed: () async {
  //             // Navigator.pop(context);
  //           },
  //           child: const Text(
  //             "Later",
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             // CollectionReference fLists =
  //             //     FirebaseFirestore.instance.collection('File Info');

  //             // if (fileModel.fileName.isNotEmpty) {
  //             //   fLists
  //             //       .doc(fileModel.fileName)
  //             //       .collection('Ratings')
  //             //       .add({
  //             //     'filename': fileModel.fileName,
  //             //     'id': fLists.id,
  //             //     "created": Timestamp.fromDate(DateTime.now()),
  //             //     'rating': fileModel.ratingValue != null
  //             //         ? fileModel.ratingValue.toString()
  //             //         : 'Rating',
  //             //   });
  //             // } else {
  //             //   print('File name is empty');
  //             // }
  //             // Navigator.pop(context);
  //           },
  //           child: const Text("Rate"),
  //         ),
  //       ],
  //     ),
  //   ],
  // );
