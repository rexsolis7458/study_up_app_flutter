// ignore: file_names
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/shadowContainer.dart';
import 'package:study_up_app/main_screens/group/group_tab.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';

class JoinGroup extends StatefulWidget
{
  final UserModel? userModel;

   const JoinGroup({super.key, this.userModel});

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<JoinGroup>
{
  TextEditingController groupNameController = TextEditingController();
  
  final UserModel _currentUser = UserModel();
  void joinGroup(BuildContext context, String groupName) async
  {
    String? returnString = await Database().joinGroup(groupName, _currentUser.id!);
    
    if (returnString == "success") {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => GroupTab(),
        ), (route) => false);
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: const <Widget>[BackButton()],
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            // child: ShadowContainer(
              child: Column(
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
                      child: Text("Join Group",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                     ),
                    ),
                    onTap: () =>
                     joinGroup(context, groupNameController.text),
                  ),
                ],
              ),
            // )
          ),
          const Spacer(),
        ],
      )
    );
  }
}