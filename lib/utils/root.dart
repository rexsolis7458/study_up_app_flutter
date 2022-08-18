
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:get/state_manager.dart';
// import 'package:study_up_app/controller/auth_controller.dart';
// import 'package:study_up_app/controller/userController.dart';
// import 'package:study_up_app/login_page.dart';
// import 'package:study_up_app/main_screens/home/home_screen.dart';

// class Root extends GetWidget<AuthController>{
//   const Root({super.key});
  
//   @override
//   Widget build(BuildContext context)
//   {
//     // Get.lazyPut(() => AuthController());
//     return GetX<AuthController>(
//       initState: (_) async{
//         Get.put<UserController>(UserController());
//       },
//       builder: (_) {
//         if (Get.find<AuthController>().user?.uid != null)
//         {
//           return HomeScreen();
//         } else {
//           return LoginPage();
//         }
//       },
//     );
//   }
// }