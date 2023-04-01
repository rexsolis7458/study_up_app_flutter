import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:study_up_app/models/users.dart';

import 'controller/auth_controller.dart';
import 'helper/const.dart';
import 'package:intl/intl.dart';

import 'other.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthController controller = Get.put(AuthController());
  AuthController authController = AuthController.instance;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;

  UserModel userModel = UserModel();

  bool _validate = false;
  
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateFields);
    _lastNameController.addListener(_validateFields);
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      _validate = _firstNameController.text.trim().isEmpty ||
          _lastNameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MainColor,
        appBar: AppBar(
          backgroundColor: MainColor,
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              // const CircleAvatar(
              //   backgroundImage: AssetImage('assets/logo.png'),
              //   radius: 40,
              // ),
              const SizedBox(
                height: 10,
              ),

              Text(
                'PERSONAL INFORMATION',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                alignment: Alignment.topLeft,
                child: Text(
                  'First Name',
                  textAlign: TextAlign.start,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Joshua Angelo",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    errorText: _validate ? 'First Name Can\'t Be Empty' : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                alignment: Alignment.topLeft,
                child: Text(
                  'Last Name',
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Alemania",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    errorText: _validate ? 'Last Name Can\'t Be Empty' : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                alignment: Alignment.topLeft,
                child: Text(
                  'Email',
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "joshuaangelo.alemania.20@usjr.edu.ph",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    errorText: _validate ? 'Email Can\'t Be Empty' : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                alignment: Alignment.topLeft,
                child: Text(
                  'Password',
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "*******",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    errorText: _validate ? 'Password Can\'t Be Empty' : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(),
              ),
              GestureDetector(
                onTap: () async {
                  bool isEmpty = _firstNameController.text.trim().isEmpty ||
                      _lastNameController.text.trim().isEmpty ||
                      _emailController.text.trim().isEmpty ||
                      _passwordController.text.trim().isEmpty;

                  setState(() {
                    _validate = isEmpty;
                  });

                  if (!isEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtherDetails(
                          _firstNameController.text.trim(),
                          _lastNameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: _validate ? Colors.grey : ButtonColor,
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                  text: "Have an account already?",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
