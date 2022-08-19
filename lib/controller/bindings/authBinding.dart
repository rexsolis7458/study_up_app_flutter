

import 'package:get/instance_manager.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/controller/userController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}