import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:study_up_app/subInterest.dart';

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

  int? degreeValue;
  int? genderValue;

  String? genderDropdownValue;
  String? degreeDropdownValue;
  List<String> genderitems = [];
  List<String> degreeitems = [];

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
    getGendersFromFirestore();
    getDegreesFromFirestore();
  }

  Future<void> getGendersFromFirestore() async {
    FirebaseFirestore.instance
        .collection('Gender')
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          genderitems = List<String>.from(querySnapshot.docs.first['items']);
        });
      } else {
        if (kDebugMode) {
          print('No documents found in the collection');
        }
      }
    }).catchError((error) => print("Error fetching gender collection: $error"));
  }

  Future<void> getDegreesFromFirestore() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Degree').limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          degreeitems = List<String>.from(querySnapshot.docs.first['items']);
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print('Error fetching degrees collection: $error');
    }
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
            const SizedBox(
              height: 10,
            ),
            Text(
              'OTHER DETAILS',
              style: const TextStyle(
                color: MainColor,
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
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton2(
                              value: genderDropdownValue == ''
                                  ? null
                                  : genderDropdownValue,
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
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    genderDropdownValue = newValue;
                                    genderValue =
                                        genderitems.indexOf(newValue!);
                                  },
                                );
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 60,
                                width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: MainColor,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton2(
                              // Initial Value
                              value: degreeDropdownValue,
                              isDense: false,

                              // Array list of items
                              items: degreeitems.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              hint: Text(""),
                              onChanged: (String? newValue) {
                                setState(() {
                                  degreeDropdownValue = newValue!;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 60,
                                width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: MainColor,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubInterest(
                      _firstName,
                      _lastName,
                      _email,
                      _password,
                      genderDropdownValue!,
                      _bdayController.text.trim(),
                      _institutionController.text.trim(),
                      degreeDropdownValue!,
                    ),
                  ),
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
                    "Next",
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
