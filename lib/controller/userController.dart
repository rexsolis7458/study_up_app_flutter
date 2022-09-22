
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  final Rx<UserModel> _userModel = UserModel().obs;

  late UserController userController;

  UserModel get user => _userModel.value;
  
  set user(UserModel value) => _userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }
  
  Future<void>saveProfileData(UserModel user) async
  {
    User currentUser = FirebaseAuth.instance.currentUser!;
    var id = user.id;
    var fname = user.fname;
    var lname = user.lname;
    var email = user.email;
    var profPic =user.profPic;
    try {
      UserModel user = UserModel(
        id: id,
        fname: fname,
        lname: lname,
        email: email,
        profPic: profPic,
      );
      if(await Database().createNewUser(user)) {
        userController.user = user;
      }
    } on Exception catch (e)
    {
      print(e.toString());
    }
  }
}