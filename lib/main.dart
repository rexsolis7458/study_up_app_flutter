import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/sign_up.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return GetMaterialApp(
      title: 'Study Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignUpPage()
    );
  }
}