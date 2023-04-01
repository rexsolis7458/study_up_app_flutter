import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';
import '../../helper/const.dart';

class JoinGroup extends StatefulWidget {
  final UserModel? userModel;

  const JoinGroup({super.key, this.userModel});

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<JoinGroup> {
  TextEditingController groupNameController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;
  final UserModel _currentUser = UserModel();
  void joinGroup(BuildContext context, String groupName) async {
    String? returnString = await Database().joinGroup(groupName, user!.uid);

    if (returnString == "success") {
      // ignore: use_build_context_synchronously
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => GroupTab(),
      //   ), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Join Group',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body:
            // Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: Row(
            //         children: const <Widget>[BackButton()],
            //       ),
            //     ),
            //     // const SizedBox(
            //     //   height: 20,
            //     // ),
            //     const Spacer(),
            //     Padding(
            //       padding: const EdgeInsets.all(20.0),
            //       // child: ShadowContainer(
            //       child:
            Column(
          children: <Widget>[
            TextFormField(
              controller: groupNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.group),
                hintText: "Group Name",
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  "Join Group",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onTap: () => joinGroup(context, groupNameController.text),
            ),
          ],
        ));
    // )

    // const Spacer(),
  }
}
