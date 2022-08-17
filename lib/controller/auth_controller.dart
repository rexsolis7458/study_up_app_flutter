import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_up_app/login_page.dart';
import 'package:study_up_app/main_screens/home/home_screen.dart';
import 'package:study_up_app/models/users.dart';

class AuthController extends GetxController {
  // AuthController.instance..
  static AuthController instance = Get.find();
  // email, password, name...
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String userCollection = "users";
  Rx<UserModel> userModel = UserModel().obs;
  
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // user would be notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("login page");
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void register() {
    try {
      auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim())
      .then((result){
        String _userId = result.user!.uid;
        addUserToFirestore(_userId);
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("About user", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text("Account creation failed"),
          messageText:
              Text(e.toString(), style: const TextStyle(color: Colors.white)));
    }
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("About Login", "Login User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text("Login failed"),
          messageText:
              Text(e.toString(), style: const TextStyle(color: Colors.white)));
    }
  }

  void logOut() async {
    auth.signOut();
  }

  addUserToFirestore(String userId)
  {
    firebaseFirestore.collection(userCollection).doc(userId).set({
      "first name": firstName.text.trim(),
      "last name": lastName.text.trim(),
      "email": email.text.trim(),
      "id": userId
    });
  }

  initilizeUserModel(String userId) async {
    userModel.value = await firebaseFirestore
    .collection(userCollection)
    .doc(userId)
    .get()
    .then((doc) => UserModel.fromSnapshot(doc));
  }
}