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

  late String genderValue;
  late String degreeValue;

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

    _bdayController.addListener(_validateFields);
    _institutionController.addListener(_validateFields);

    //   _minDate=DateTime(2020,3,5,9,0,0);
    // _maxDate=DateTime(2020,3,25,9,0,0);
  }

  void _validateFields() {
    setState(() {
      _validate = _bdayController.text.trim().isEmpty ||
          _institutionController.text.trim().isEmpty;
    });
  }

  bool _validate = false;

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
                  errorText: _validate ? 'Date of Birth Can\'t Be Empty' : null,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(new FocusNode());

                  date = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 6570)),
                    firstDate: DateTime(1990, 9, 7, 17, 30),
                    lastDate:
                        DateTime.now().subtract(const Duration(days: 6570)),
                  );

                  if (date != null) {
                    print(date);
                    String formattedDate =
                        DateFormat('MM-dd-yyyy').format(date);
                    print(formattedDate);
                    setState(() {
                      _bdayController.text =
                          formattedDate; // set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                            setState(
                              () {
                                genderDropdownValue = newValue!;
                              },
                            );
                            validator:
                            (String value) {
                              if (value?.isEmpty ?? true) {
                                return 'Kindly select a gender.';
                              }
                            };
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
                  errorText: _validate ? 'Institution Can\'t Be Empty' : null,
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
                            setState(
                              () {
                                degreeDropdownValue = newValue!;
                              },
                            );
                            validator:
                            (String value) {
                              if (value?.isEmpty ?? true) {
                                return 'Kindly select a degree.';
                              }
                            };
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
                if (_firstName.trim().isEmpty ||
                    _lastName.trim().isEmpty ||
                    _email.trim().isEmpty ||
                    _password.trim().isEmpty ||
                    _bdayController.text.trim().isEmpty ||
                    genderDropdownValue == null ||
                    _institutionController.text.trim().isEmpty ||
                    degreeDropdownValue == null) {
                  // Show a warning message that some data is missing
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Missing Data'),
                        content: const Text(
                            'Please fill in all the required fields.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  DateTime dob =
                      DateFormat("MM-dd-yyyy").parse(_bdayController.text);
                  DateTime now = DateTime.now();
                  Duration difference = now.difference(dob);
                  int age = difference.inDays ~/ 365;

                  String ageString = age.toString();
                  // Proceed with the registration process
                  authController.register(
                    _firstName.trim(),
                    _lastName.trim(),
                    _email.trim(),
                    _password.trim(),
                    _bdayController.text.trim(),
                    genderDropdownValue!,
                    _institutionController.text.trim(),
                    degreeDropdownValue!,
                    ageString,
                  );
                }
              },
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: _validate ? Colors.grey : ButtonColor,
                ),
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
