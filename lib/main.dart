import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/controller/bindings/authBinding.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/provider/event_provider.dart';
import 'package:study_up_app/sign_up.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Get.lazyPut(() => AuthController(), tag: "Auth Controller");
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  await Firebase.initializeApp().then((value) => Get.put(UserController()));

//   await FirebaseFirestore.instance.collection('Subjects').add({
//   'items': [
//     'COMP 1 - Introduction to Computing',
// 'PROG 1 - Computer Programming 1',
// 'EMC CORE 1 - Freehand and Digital Drawing',
// 'CMP - Computing Math Prep',
// 'EMC CORE 2 - Introduction to Game Design and Development',
// 'PROG 2 - Computer Programming 2',
// 'DVA - Digital Visual Art',
// 'DISCRETE 1 - Discrete Structure 1',
// 'DIGITAL - Digital Logic Design',
// 'DATASTRUCT - Data Structure and Algorithms',
// 'EMC CORE 3 - Introduction to 2D Animation',
// 'EMC CORE 4 - Principles of 3D Animation',
// 'EMC SP 1 - Applied Mathematics for Games',
// 'OOP - Object Oriented Programming',
// 'IM 1 - Information Management 1',
// 'EMC CORE 5 - Computer Graphics Programming',
// 'EMC SP 2 - Applied Game Physics',
// 'HCI - Human Computer Interaction',
// 'EMC CORE 7 - Digital Sound',
// 'EMC CORE 8 - Script Writing and Storyboard Design',
// 'APPSDEV 1 - Applications Development and Emerging Technologies',
// 'NET 1 - Data Communications and Networking 1',
// 'EMC CORE 9 - Game Design and Production Process',
// 'EMC SP 3 - 2D Game Programming',
// 'EMC SP 4 - Artificial Intelligence in Games',
// 'RESEARCH 1 - Methods of Research in Computing',
// 'SOFTENG - Software Engineering',
// 'OS - Operating System',
// 'EMC SP 5 - 3D Game Programming',
// 'EMC SP 6 - Advanced Game Programming (Game Engine)',
// 'EMC SP 7 - Game Networking',
// 'EMC SP 8 - Advanced Game Design',
// 'PROF ELEC 1 - Professional Elective 1',
// 'CAPSTONE 1 - Capstone Project 1',
// 'TECHNO - Technopreneurship',
// 'SP - Social Issues and Professional Practice',
// 'EMC SP 9 - Game Production',
// 'CAPSTONE 2 - Capstone Project 2',
// 'ITREVIEW - Certification Exam Review',
// 'IS - Fundamentals of Information Systems',
// 'WEB - Web Development',
// 'PT - Platform Technologies',
// 'DM 1 - Organization and Management Concepts',
// 'DM 2 - Financial Management',
// 'QM - Quantitative Methods',
// 'IS ELEC 1 - Fundamentals of Business Analytics',
// 'HCI - Human Computer Interaction',
// 'EA - Enterprise Architecture',
// 'DM 3 - Business Process Management',
// 'SAD - System Analysis and Design',
// 'ERP - Enterprise Resource Planning',
// 'DM 4 - Evaluation of Business Performance',
// 'PROJ MGT 1 - IS Project Management 1',
// 'APPSDEV 2 - Applications Development and Emerging Technologies 2',
// 'IAS - Information Assurance and Security',
// 'SA - Systems Administration and Maintenance',
// 'PROJ MGT 2 - IS Project Management 2',
// 'STRAT MGT - IS Strategy, Management, and Acquisition',
// 'IM 2 - Information Management 2',
// 'NET 2 - Data Communications and Networking 2',
// 'ADV CMP - Calculus',
// 'ECPROG - Enrichment Course in Computer Programming',
// 'COMP - ORG 1 - Computer Organization and Architecture',
// 'ALGO - Analysis and Design of Algorithms',
// 'AUTOMATA - Automata Theory and Formal Languages',
// 'CS ELEC 1 - Intelligent Systems',
// 'PL - Programming Languages',
//   ]
// });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => EventProvider(),
      // Get.lazyPut(() => UserController(), tag: "User Controller");
      child: GetMaterialApp(
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
        home:  SignUpPage(),
      ));

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