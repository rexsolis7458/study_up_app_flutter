import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/helper/const.dart';

class SignUpPage extends GetWidget<AuthController>
{
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    FirebaseAuth _auth = FirebaseAuth.instance;
    AuthController authController = AuthController.instance;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: KTweeterColor,
        appBar: AppBar(
          backgroundColor: KTweeterColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Register',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              radius: 40,
            ),
            const SizedBox(
                height: 10,
              ),
              const Text('StudyUp'),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "First Name",
                    hintStyle: TextStyle(color: Colors.grey[350]),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Last Name",
                    hintStyle: TextStyle(color: Colors.grey[350]),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey[350]),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey[350]),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  authController.register(
                    firstNameController.text.trim(),
                    lastNameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                  text: TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.back(),
                      text: "Have an account already?",
                      style: TextStyle(fontSize: 20, color: Colors.black54))),
              const SizedBox(
                height: 0.16,
              ),
          ],
        ),
      ),
    );
  }
}