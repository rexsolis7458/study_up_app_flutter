import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_up_app/login_page.dart';
import 'package:study_up_app/main_screens/home/home_screen.dart';

class AuthController extends GetxController {
  // AuthController.instance..
  static AuthController instance = Get.find();
  // email, password, name...
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

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

  void register(String email, password) {
    try {
      auth.createUserWithEmailAndPassword(email: email, password: password);
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
}