import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/group_tab.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';
import 'package:intl/intl.dart';

class CreateGroup extends StatefulWidget {
  final UserModel? userModel;

  const CreateGroup({super.key, this.userModel});

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;
  final UserModel _currentUser = UserModel();
  void creatingGroup(BuildContext context, String groupName) async {
    String? returnString = await Database().createGroup(groupName, user!.uid);

    if (returnString == "success") {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => GroupTab(),
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    _from.text = "";
    _to.text = "";
    super.initState();
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
                child: Text(
                  'Time Available',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    child: Text(
                      'From',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 120, top: 5, right: 120),
                    child: TextFormField(
                      controller: _from,
                      decoration: InputDecoration(
                        // labelText: "Date of Birth",
                        icon: Icon(Icons.timer),
                        hintText: "Enter Time",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          print(pickedTime.format(context)); //output 10:51 PM
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          //converting to DateTime so that we can further format on different pattern.
                          print(parsedTime); //output 1970-01-01 22:53:00.000
                          String formattedTime =
                              DateFormat('HH:mm').format(parsedTime);
                          print(formattedTime); //output 14:59:00
                          //DateFormat() is from intl package, you can format the time on any pattern you need.

                          setState(() {
                            _from.text =
                                formattedTime; //set the value of text field.
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    'To',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 120, top: 5, right: 120),
                    child: TextFormField(
                      controller: _to,
                      decoration: InputDecoration(
                        // labelText: "Date of Birth",
                        icon: Icon(Icons.timer),
                        hintText: "Enter Time",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          print(pickedTime.format(context)); //output 10:51 PM
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          //converting to DateTime so that we can further format on different pattern.
                          print(parsedTime); //output 1970-01-01 22:53:00.000
                          String formattedTime =
                              DateFormat('HH:mm').format(parsedTime);
                          print(formattedTime); //output 14:59:00
                          //DateFormat() is from intl package, you can format the time on any pattern you need.

                          setState(() {
                            _to.text =
                                formattedTime; //set the value of text field.
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
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
                onTap: () => creatingGroup(context, groupNameController.text),
              ),
            ],
          ),
          // )
        ),
        const Spacer(),
      ],
    ));
  }
}
