import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/services/py_services.dart';
import 'package:study_up_app/services/response.dart';
import 'package:study_up_app/sign_up.dart';

PyService pyService = new PyService();

Future<APiResponse<Map<String, dynamic>>> extractInformation() async {
  return await pyService.extractInformation();
}

// ignore: must_be_immutable
class LoginPage extends GetWidget<AuthController> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
            'Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
                radius: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Study Up',
                style: const TextStyle(
                  color: SecondaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                    labelStyle: TextStyle(color: Colors.grey[350]),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Password",
                    labelStyle: TextStyle(color: Colors.grey[350]),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await extractInformation();
                  print(result.data!['result']);
                  AuthController.instance.login(emailController.text.trim(),
                      passwordController.text.trim());
                },
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ButtonColor),
                  child: const Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                    text: "Don't have an account yet?",
                    style: TextStyle(color: Colors.black54, fontSize: 20),
                    children: [
                      TextSpan(
                          text: " Create",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => SignUpPage()))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
