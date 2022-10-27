import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';

import 'package:study_up_app/main_screens/group/group.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  @override
  Widget build(BuildContext context) {
    var subjectController = TextEditingController();
    var schoolNameController = TextEditingController();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Join a Group',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
            child: TextField(
              obscureText: true,
              controller: subjectController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Subject",
                hintStyle: TextStyle(color: Colors.grey[350]),
              ),
            ),
          ),
          const SizedBox(
            width: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
            child: TextField(
              obscureText: true,
              controller: schoolNameController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "School Name",
                hintStyle: TextStyle(color: Colors.grey[350]),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Group(),
                ),
              );
            },
            child: Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: ButtonColor),
              child: Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
