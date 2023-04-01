// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:study_up_app/models/users.dart';
// import 'controller/auth_controller.dart';
// import 'helper/const.dart';

// class OtherDetails extends StatefulWidget {
//   @override
//   _OtherDetailsState createState() => _OtherDetailsState();
// }

// class _OtherDetailsState extends State<OtherDetails> {
//   final AuthController controller = Get.put(AuthController());
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   AuthController authController = AuthController.instance;

//   late String _firstName;
//   late String _lastName;
//   late String _email;
//   late String _password;

//   TextEditingController _bdayController = TextEditingController();
//   TextEditingController _institutionController = TextEditingController();

//   int? genderValue;
//   int? degreeValue;

//   String genderDropdownValue = 'Male';
//   String degreeDropdownValue = 'BSIT';
//   var genderitems = [
//     'Male',
//     'Female',
//     'Others',
//   ];

//   var degreeitems = [
//     'BSIT',
//     'BSCS',
//     'BSEMC',
//     'BSIS',
//     'Others',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: MainColor,
//       appBar: AppBar(
//         backgroundColor: MainColor,
//         centerTitle: true,
//         elevation: 0,
//         title: const Text(
//           'Register',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const SizedBox(
//               height: 15,
//             ),
//             const CircleAvatar(
//               backgroundImage: AssetImage('assets/logo.png'),
//               radius: 40,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Text('StudyUp'),
//             const SizedBox(
//               height: 20,
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//               child: TextFormField(
//                 controller: _bdayController,
//                 decoration: InputDecoration(
//                   // labelText: "Date of Birth",
//                   hintText: "Date of Birth",
//                   hintStyle: TextStyle(color: Colors.grey[600]),
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 3),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onTap: () async {
//                   DateTime date = DateTime(1900);
//                   FocusScope.of(context).requestFocus(new FocusNode());

//                   date = (await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime(2100)))!;

//                   _bdayController.text = date.toString();

//                   if (date != null) {
//                     print(date);
//                     String formattedDate =
//                         DateFormat('dd-MM-yyyy').format(date);
//                     print(formattedDate);
//                     setState(() {
//                       _bdayController.text =
//                           formattedDate; //set output date to TextField value.
//                     });
//                   } else {
//                     print("Date is not selected");
//                   }
//                 },
//                 validator: (value) {
//                   if (value!.isEmpty || value.length < 1) {
//                     return 'Choose Date';
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(
//                       10,
//                     )),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 10, top: 5, right: 30),
//                       child: Text(
//                         'Gender',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         DropdownButton(
//                           // Initial Value
//                           value: genderDropdownValue,

//                           // Down Arrow Icon
//                           icon: const Icon(Icons.keyboard_arrow_down),

//                           // Array list of items
//                           items: genderitems.map((String items) {
//                             return DropdownMenuItem(
//                               value: items,
//                               child: Text(
//                                 items,
//                                 style: TextStyle(
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                           // After selecting the desired option,it will
//                           // change button value to selected value
//                           onChanged: (String? newValue) {
//                             genderDropdownValue = newValue!;
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//               child: TextField(
//                 controller: _institutionController,
//                 decoration: InputDecoration(
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 3),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   hintText: "Institution",
//                   hintStyle: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(
//                       10,
//                     )),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 10, top: 5, right: 30),
//                       child: Text(
//                         'Degree',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         DropdownButton(
//                           // Initial Value
//                           value: degreeDropdownValue,

//                           // Down Arrow Icon
//                           icon: const Icon(Icons.keyboard_arrow_down),

//                           // Array list of items
//                           items: degreeitems.map((String items) {
//                             return DropdownMenuItem(
//                               value: items,
//                               child: Text(
//                                 items,
//                                 style: TextStyle(
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                           // After selecting the desired option,it will
//                           // change button value to selected value
//                           onChanged: (String? newValue) {
//                             degreeDropdownValue = newValue!;
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 30),
//               child: Container(),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 authController.register(
//                   _firstName.trim(),
//                   _lastName.trim(),
//                   _email.trim(),
//                   _password.trim(),
//                   _bdayController.text.trim(),
//                   genderDropdownValue,
//                   _institutionController.text.trim(),
//                   degreeDropdownValue,
//                 );
//               },
//               child: Container(
//                 width: 150,
//                 height: 40,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: ButtonColor),
//                 child: const Center(
//                   child: Text(
//                     "Sign Up",
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
