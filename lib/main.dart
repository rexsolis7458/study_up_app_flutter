import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/controller/bindings/authBinding.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/home/home_screen.dart';
import 'package:study_up_app/sign_up.dart';
import 'package:study_up_app/utils/root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Get.lazyPut(() => AuthController(), tag: "Auth Controller");
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  await Firebase.initializeApp().then((value) => Get.put(UserController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(() => UserController(), tag: "User Controller");
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      title: 'Study Up',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: MainColor,
          onPrimary: SecondaryColor,
          secondary: SecondaryColor,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: BGColor,
          onBackground: BGColor,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      home: const SignUpPage(),
    );
  }
   Widget roundedButton(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: ButtonColor, borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 48,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 15.5),
      ),
    );
  }
}
  