import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller/auth_controller.dart';
import 'helper/const.dart';

class OtherDetails extends StatefulWidget {
  String firstName;
  String lastName;
  String email;
  String password;

  OtherDetails(this.firstName, this.lastName, this.email, this.password);

  @override
  _OtherDetailsState createState() => _OtherDetailsState();
}

class _OtherDetailsState extends State<OtherDetails> {
  final AuthController controller = Get.put(AuthController());
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthController authController = AuthController.instance;

  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;

  TextEditingController _bdayController = TextEditingController();
  TextEditingController _institutionController = TextEditingController();

  int? genderValue;
  int? degreeValue;

  String genderDropdownValue = 'Male';
  String degreeDropdownValue = 'BSIT';
  var genderitems = [
    'Male',
    'Female',
    'Others',
  ];

  var degreeitems = [
    'BSIT',
    'BSCS',
    'BSEMC',
    'BSIS',
    'Others',
  ];
  late DateTime _minDate, _maxDate;

  DateTime today = DateTime.now();
  late String birthDateString;
  @override
  void initState() {
    super.initState();
    _firstName = widget.firstName;
    _lastName = widget.lastName;
    _email = widget.email;
    _password = widget.password;

    //   _minDate=DateTime(2020,3,5,9,0,0);
    // _maxDate=DateTime(2020,3,25,9,0,0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MainColor,
      appBar: AppBar(
        backgroundColor: MainColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Register',
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
            // const CircleAvatar(
            //   backgroundImage: AssetImage('assets/logo.png'),
            //   radius: 40,
            // ),
            const SizedBox(
              height: 10,
            ),

            Text(
              'OTHER DETAILS',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              alignment: Alignment.topLeft,
              child: Text(
                'Date of Birth',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              child: TextFormField(
                controller: _bdayController,
                decoration: InputDecoration(
                  // labelText: "Date of Birth",
                  hintText: "08-18-1998",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                  DateTime date = DateTime(1900);
                  FocusScope.of(context).requestFocus(new FocusNode());

                  date = (await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.now().subtract(const Duration(days: 6570)),
                      firstDate: DateTime(1990, 9, 7, 17, 30),
                      lastDate: DateTime.now()
                          .subtract(const Duration(days: 6570))))!;

                  _bdayController.text = date.toString();

                  if (date != null) {
                    print(date);
                    String formattedDate =
                        DateFormat('MM-dd-yyyy').format(date);
                    print(formattedDate);
                    setState(() {
                      _bdayController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                validator: (value) {
                  if (value!.isEmpty || value.length < 1) {
                    return 'Choose Date';
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              alignment: Alignment.topLeft,
              child: Text(
                'Gender',
                textAlign: TextAlign.start,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    )),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 100, top: 5, right: 30),
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton(
                          // Initial Value
                          value: genderDropdownValue,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: genderitems.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            genderDropdownValue = newValue!;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              alignment: Alignment.topLeft,
              child: Text(
                'Institution',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              child: TextField(
                controller: _institutionController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "USJR",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              alignment: Alignment.topLeft,
              child: Text(
                'Degree',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    )),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 100, top: 5, right: 30),
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton(
                          // Initial Value
                          value: degreeDropdownValue,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: degreeitems.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            degreeDropdownValue = newValue!;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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
              onTap: () async {
                authController.register(
                  _firstName.trim(),
                  _lastName.trim(),
                  _email.trim(),
                  _password.trim(),
                  _bdayController.text.trim(),
                  genderDropdownValue,
                  _institutionController.text.trim(),
                  degreeDropdownValue,
                );
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
            const SizedBox(
              height: 30,
            ),
            RichText(
              text: TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                text: "Have an account already?",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
