import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/login_page.dart';
import 'package:study_up_app/main_screens/home/home_screen.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';

class AuthController extends GetxController {
  // AuthController.instance..
  static AuthController instance = Get.find();
  // email, password, name...
  late Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  // User? get user => firebaseUser.value;

  late DocumentReference reference;

  // String userCollection = "users";
  Rx<UserModel> userModel = UserModel().obs;

  get user => null;

  @override
  // onInit() {
  //   _user.bindStream(auth.onAuthStateChanged);
  // }
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    // user would be notified
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("login page");
      Get.offAll(() => LoginPage());
    } else {
      reference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid);
      Get.offAll(() => HomeScreen());
    }
  }

  void register(
    String firstname,
    String lastname,
    String email,
    String password,
    String birthday,
    String gender,
  ) async {
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      UserModel users = UserModel(
        email: authResult.user!.email,
        id: authResult.user!.uid,
        firstname: firstname,
        lastname: lastname,
        password: password,
        birthday: birthday,
        gender: gender,
      );
      if (await Database().createNewUser(users)) {
        Get.find<UserController>().user = users;
        Get.back();
      }
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
    try {
      auth.signOut();
      Get.find<UserController>().clear();
    } catch (e) {
      Get.snackbar("Error signing out", "error",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
