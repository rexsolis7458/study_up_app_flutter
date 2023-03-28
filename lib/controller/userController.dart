import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  final Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user => _userModel.value;

  set user(UserModel value) => _userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }

  // void updateDisplayName(String displayName) {
  //   UserController.displayName = displayName;
  //   _auth
  // }

  Future<void> saveProfileData(UserModel user) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    var id = user.id;
    var firstname = user.firstname;
    var lastname = user.lastname;
    var email = user.email;
    var profilePicture = user.profilePicture;
    var birthday = user.birthday;
    var gender = user.gender;
    try {
      UserModel user = UserModel(
        id: id,
        firstname: firstname,
        lastname: lastname,
        email: email,
        profilePicture: profilePicture,
        birthday: birthday,
        gender: gender,
      );
      if (await Database().createNewUser(user)) {
        this.user = user;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
