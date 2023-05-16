import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/MultiSelect.dart';
import 'package:study_up_app/main_screens/group/group_tab.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';
import 'package:intl/intl.dart';

import '../home/home_screen.dart';

class CreateGroup extends StatefulWidget {
  final UserModel? userModel;

  const CreateGroup({super.key, this.userModel});

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController groupNameController = TextEditingController();
  final TextEditingController _from = TextEditingController();
  final TextEditingController _to = TextEditingController();

  List<String> _subjectItems = [];
  List<String> _selectedSubjects = [];

  List<String> _selectedValues = [];

  final User? user = FirebaseAuth.instance.currentUser;
  final UserModel _currentUser = UserModel();
  void creatingGroup(BuildContext context, String groupName,
      List<String> selectedValues, String from, String to) async {
    String? returnString = await Database()
        .createGroup(groupName, user!.uid, selectedValues, from, to);

    if (returnString == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  String convertToMilitaryTime(String time) {
    String suffix = time.substring(time.length - 2);
    List<String> parts = time.substring(0, time.length - 2).split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    if (suffix.toLowerCase() == "pm" && hour != 12) {
      hour += 12;
    } else if (suffix.toLowerCase() == "am" && hour == 12) {
      hour = 0;
    }

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

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
  void initState() {
    _from.text = "";
    _to.text = "";
    super.initState();
    getSubjectsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
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
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                child: const Text(
                  'Time Available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'From',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextFormField(
                          controller: _from,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.timer),
                            hintText: "Enter Time",
                            hintStyle: TextStyle(color: Colors.grey[600]),
                          ),
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              DateTime now = DateTime.now();
                              DateTime pickedDateTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  pickedTime.hour,
                                  pickedTime.minute);

                              String formattedTime =
                                  DateFormat('hh:mm a').format(pickedDateTime);
                              setState(() {
                                _from.text = formattedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'To',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextFormField(
                          controller: _to,
                          decoration: InputDecoration(
                            icon: const Icon(Icons.timer),
                            hintText: "Enter Time",
                            hintStyle: TextStyle(color: Colors.grey[600]),
                          ),
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              DateTime now = DateTime.now();
                              DateTime pickedDateTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  pickedTime.hour,
                                  pickedTime.minute);

                              String formattedTime =
                                  DateFormat('hh:mm a').format(pickedDateTime);
                              setState(() {
                                _to.text = formattedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              MultiSelectDropdown(
                options: _subjectItems,
                hintText: 'Select options',
                onSelected: (List<String> selectedList) {
                  setState(() {
                    _selectedSubjects = selectedList;
                  });
                },
              ),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Text(
                    "Create Group",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onTap: () async {
                  // Check if all required fields are filled out
                  if (groupNameController.text.isEmpty ||
                      _selectedSubjects.isEmpty ||
                      _from.text.isEmpty ||
                      _to.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Missing Information"),
                          content: const Text(
                              "Please fill out all required fields."),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Check if the group name already exists
                    final groupSnapshots = await FirebaseFirestore.instance
                        .collection('groups')
                        .where('groupName', isEqualTo: groupNameController.text)
                        .get();
                    if (groupSnapshots.docs.isNotEmpty) {
                      // Group name already exists
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Group Name Already Exists"),
                            content: const Text(
                                "Please choose a different group name."),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _from.text = convertToMilitaryTime(_from.text);
                      _to.text = convertToMilitaryTime(_to.text);
                      // Group name does not exist, create the group
                      // ignore: use_build_context_synchronously
                      creatingGroup(context, groupNameController.text,
                          _selectedSubjects, _from.text, _to.text);
                    }
                  }
                },
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    ));
  }
}
