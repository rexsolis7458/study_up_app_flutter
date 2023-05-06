import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller/auth_controller.dart';
import 'helper/MultiSelect.dart';
import 'helper/const.dart';

class SubInterest extends StatefulWidget {
  @override
  _SubInterestState createState() => _SubInterestState();
}

class _SubInterestState extends State<SubInterest> {

  List<String> _subjectItems = [];
  List<String> _selectedSubjects = [];

  Future<void> getSubjectsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Subjects')
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _subjectItems = List<String>.from(querySnapshot.docs.first['items']);
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print("Error fetching subjects collection: $error");
    }
  }

  @override
  void initState(){
    getSubjectsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: BGColor,
        appBar: AppBar(
          backgroundColor: BGColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Subject Interest',
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, top: 5, right: 30),
                  alignment: Alignment.topLeft,
                  child: MultiSelectDropdown(
                    options: _subjectItems,
                    hintText: 'Select options',
                    onSelected: (List<String> selectedList) {
                      setState(() {
                        _selectedSubjects = selectedList;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    // if (_firstName.trim().isEmpty ||
                    //     _lastName.trim().isEmpty ||
                    //     _email.trim().isEmpty ||
                    //     _password.trim().isEmpty ||
                    //     _bdayController.text.trim().isEmpty ||
                    //     genderDropdownValue == null ||
                    //     _institutionController.text.trim().isEmpty ||
                    //     degreeDropdownValue == null) {
                    //   // Show a warning message that some data is missing
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         title: const Text('Missing Data'),
                    //         content: const Text(
                    //             'Please fill in all the required fields.'),
                    //         actions: <Widget>[
                    //           TextButton(
                    //             onPressed: () => Navigator.of(context).pop(),
                    //             child: const Text('OK'),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    // } else {
                    //   DateTime dob =
                    //       DateFormat("MM-dd-yyyy").parse(_bdayController.text);
                    //   DateTime now = DateTime.now();
                    //   Duration difference = now.difference(dob);
                    //   int age = difference.inDays ~/ 365;

                    //   String ageString = age.toString();
                    //   // Proceed with the registration process
                    //   authController.register(
                    //     _firstName.trim(),
                    //     _lastName.trim(),
                    //     _email.trim(),
                    //     _password.trim(),
                    //     _bdayController.text.trim(),
                    //     genderDropdownValue!,
                    //     _institutionController.text.trim(),
                    //     degreeDropdownValue!,
                    //     ageString,
                    //   );
                    // }
                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ButtonColor),
                    child: const Center(
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
              ]),
        ));
  }
}
