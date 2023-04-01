// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:study_up_app/models/users.dart';

// import 'controller/auth_controller.dart';
// import 'helper/const.dart';
// import 'package:intl/intl.dart';

// import 'otherDetails.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final AuthController controller = Get.put(AuthController());
//   AuthController authController = AuthController.instance;

//   TextEditingController _firstNameController = TextEditingController();
//   TextEditingController _lastNameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   late String _firstName;
//   late String _lastName;
//   late String _email;
//   late String _password;

//   UserModel userModel = UserModel();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             backgroundColor: MainColor,
//             appBar: AppBar(
//               backgroundColor: MainColor,
//               centerTitle: true,
//               elevation: 0,
//               title: const Text(
//                 'Register',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   const CircleAvatar(
//                     backgroundImage: AssetImage('assets/logo.png'),
//                     radius: 40,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Text('StudyUp'),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       'Name',
//                       textAlign: TextAlign.start,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                     child: TextField(
//                       controller: _firstNameController,
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderSide: const BorderSide(width: 3),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         hintText: "First Name",
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                     child: TextField(
//                       controller: _lastNameController,
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderSide: const BorderSide(width: 3),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         hintText: "Last Name",
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                     child: TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderSide: const BorderSide(width: 3),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         hintText: "Email",
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                     child: TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderSide: const BorderSide(width: 3),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         hintText: "Password",
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                   //   child: TextFormField(
//                   //     controller: _bdayController,
//                   //     decoration: InputDecoration(
//                   //       // labelText: "Date of Birth",
//                   //       hintText: "Date of Birth",
//                   //       hintStyle: TextStyle(color: Colors.grey[600]),
//                   //       fillColor: Colors.white,
//                   //       filled: true,
//                   //       border: OutlineInputBorder(
//                   //         borderSide: const BorderSide(width: 3),
//                   //         borderRadius: BorderRadius.circular(12),
//                   //       ),
//                   //     ),
//                   //     onTap: () async {
//                   //       DateTime date = DateTime(1900);
//                   //       FocusScope.of(context).requestFocus(new FocusNode());

//                   //       date = (await showDatePicker(
//                   //           context: context,
//                   //           initialDate: DateTime.now(),
//                   //           firstDate: DateTime(1900),
//                   //           lastDate: DateTime(2100)))!;

//                   //       _bdayController.text = date.toString();

//                   //       if (date != null) {
//                   //         print(date);
//                   //         String formattedDate =
//                   //             DateFormat('dd-MM-yyyy').format(date);
//                   //         print(formattedDate);
//                   //         setState(() {
//                   //           _bdayController.text =
//                   //               formattedDate; //set output date to TextField value.
//                   //         });
//                   //       } else {
//                   //         print("Date is not selected");
//                   //       }
//                   //     },
//                   //     validator: (value) {
//                   //       if (value!.isEmpty || value.length < 1) {
//                   //         return 'Choose Date';
//                   //       }
//                   //     },
//                   //   ),
//                   // ),
//                   // const SizedBox(
//                   //   height: 15,
//                   // ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                   //   child: Container(
//                   //     decoration: BoxDecoration(
//                   //         color: Colors.white,
//                   //         borderRadius: BorderRadius.circular(
//                   //           10,
//                   //         )),
//                   //     child: Row(
//                   //       children: [
//                   //         Padding(
//                   //           padding: const EdgeInsets.only(
//                   //               left: 10, top: 5, right: 30),
//                   //           child: Text(
//                   //             'Gender',
//                   //             style: TextStyle(
//                   //               color: Colors.grey[600],
//                   //             ),
//                   //           ),
//                   //         ),
//                   //         Column(
//                   //           crossAxisAlignment: CrossAxisAlignment.center,
//                   //           mainAxisAlignment: MainAxisAlignment.center,
//                   //           children: <Widget>[
//                   //             DropdownButton(
//                   //               // Initial Value
//                   //               value: genderDropdownValue,

//                   //               // Down Arrow Icon
//                   //               icon: const Icon(Icons.keyboard_arrow_down),

//                   //               // Array list of items
//                   //               items: genderitems.map((String items) {
//                   //                 return DropdownMenuItem(
//                   //                   value: items,
//                   //                   child: Text(
//                   //                     items,
//                   //                     style: TextStyle(
//                   //                       color: Colors.black54,
//                   //                     ),
//                   //                   ),
//                   //                 );
//                   //               }).toList(),
//                   //               // After selecting the desired option,it will
//                   //               // change button value to selected value
//                   //               onChanged: (String? newValue) {
//                   //                 genderDropdownValue = newValue!;
//                   //               },
//                   //             ),
//                   //           ],
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   // const SizedBox(
//                   //   height: 15,
//                   // ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                   //   child: TextField(
//                   //     controller: _institutionController,
//                   //     obscureText: true,
//                   //     decoration: InputDecoration(
//                   //       fillColor: Colors.white,
//                   //       filled: true,
//                   //       border: OutlineInputBorder(
//                   //         borderSide: const BorderSide(width: 3),
//                   //         borderRadius: BorderRadius.circular(12),
//                   //       ),
//                   //       hintText: "Institution",
//                   //       hintStyle: TextStyle(color: Colors.grey[600]),
//                   //     ),
//                   //   ),
//                   // ),
//                   // const SizedBox(
//                   //   height: 15,
//                   // ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                   //   child: Container(
//                   //     decoration: BoxDecoration(
//                   //         color: Colors.white,
//                   //         borderRadius: BorderRadius.circular(
//                   //           10,
//                   //         )),
//                   //     child: Row(
//                   //       children: [
//                   //         Padding(
//                   //           padding: const EdgeInsets.only(
//                   //               left: 10, top: 5, right: 30),
//                   //           child: Text(
//                   //             'Degree',
//                   //             style: TextStyle(
//                   //               color: Colors.grey[600],
//                   //             ),
//                   //           ),
//                   //         ),
//                   //         Column(
//                   //           crossAxisAlignment: CrossAxisAlignment.center,
//                   //           mainAxisAlignment: MainAxisAlignment.center,
//                   //           children: <Widget>[
//                   //             DropdownButton(
//                   //               // Initial Value
//                   //               value: degreeDropdownValue,

//                   //               // Down Arrow Icon
//                   //               icon: const Icon(Icons.keyboard_arrow_down),

//                   //               // Array list of items
//                   //               items: degreeitems.map((String items) {
//                   //                 return DropdownMenuItem(
//                   //                   value: items,
//                   //                   child: Text(
//                   //                     items,
//                   //                     style: TextStyle(
//                   //                       color: Colors.black54,
//                   //                     ),
//                   //                   ),
//                   //                 );
//                   //               }).toList(),
//                   //               // After selecting the desired option,it will
//                   //               // change button value to selected value
//                   //               onChanged: (String? newValue) {
//                   //                 degreeDropdownValue = newValue!;
//                   //               },
//                   //             ),
//                   //           ],
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   // const SizedBox(
//                   //   height: 15,
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30),
//                     child: Container(),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       _firstNameController.text.trim();
//                       _lastNameController.text.trim();
//                       _emailController.text.trim();
//                       _passwordController.text.trim();

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => OtherDetails(
//                             _firstName: _firstNameController.text.trim(),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: 150,
//                       height: 40,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           color: ButtonColor),
//                       child: const Center(
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   RichText(
//                       text: TextSpan(
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () => Get.back(),
//                           text: "Have an account already?",
//                           style:
//                               TextStyle(fontSize: 20, color: Colors.black54))),
//                   const SizedBox(
//                     height: 50,
//                   ),
//                 ],
//               ),
//             )));
//   }
// }



// // class SignupPageSample extends StatefulWidget {
// //   @override
// //   _SignupPageSampleState createState() => _SignupPageSampleState();
// // }

// // class _SignupPageSampleState extends State<SignupPageSample> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _auth = FirebaseAuth.instance;

// //   late String _firstName;
// //   late String _lastName;
// //   late String _email;
// //   late String _password;
// //   late String _institution;
// //   String data = '';

// //   AuthController authController = AuthController.instance;

// //   int? genderValue;
// //   int? degreeeValue;

// //   String genderDropdownValue = 'Male';
// //   String degreeDropdownValue = 'BSIT';
// //   var genderitems = [
// //     'Male',
// //     'Female',
// //     'Others',
// //   ];

// //   var degreeitems = [
// //     'BSIT',
// //     'BSCS',
// //     'BSEMC',
// //     'BSIS',
// //     'Others',
// //   ];

// //   TextEditingController bdayController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       resizeToAvoidBottomInset: false,
// //       backgroundColor: MainColor,
// //       appBar: AppBar(
// //         backgroundColor: MainColor,
// //         centerTitle: true,
// //         elevation: 0,
// //         title: const Text(
// //           'Register',
// //           style: TextStyle(
// //             fontSize: 20,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               TextFormField(
// //                 decoration: InputDecoration(
// //                   labelText: 'First Name',
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter your first name';
// //                   }
// //                   return null;
// //                 },
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _firstName = value.trim();
// //                   });
// //                 },
// //               ),
// //               TextFormField(
// //                 decoration: InputDecoration(
// //                   labelText: 'Last Name',
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter your last name';
// //                   }
// //                   return null;
// //                 },
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _lastName = value.trim();
// //                   });
// //                 },
// //               ),
// //               TextFormField(
// //                 decoration: InputDecoration(
// //                   labelText: 'Email',
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter your email';
// //                   }
// //                   return null;
// //                 },
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _email = value.trim();
// //                   });
// //                 },
// //               ),
// //               TextFormField(
// //                 obscureText: true,
// //                 decoration: InputDecoration(
// //                   labelText: 'Password',
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter your password';
// //                   }
// //                   return null;
// //                 },
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _password = value.trim();
// //                   });
// //                 },
// //               ),
// //               const SizedBox(
// //                 height: 15,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 30),
// //                 child: Container(
// //                   child: Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text("Date of Birth"),
// //                   ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 30),
// //                 child: Container(
// //                   child: Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: TextFormField(
// //                       controller: bdayController,
// //                       decoration: InputDecoration(
// //                         labelText: "Date of Birth",
// //                         hintText: "Date of Birth",
// //                       ),
// //                       onTap: () async {
// //                         DateTime date = DateTime(1900);
// //                         FocusScope.of(context).requestFocus(new FocusNode());

// //                         date = (await showDatePicker(
// //                             context: context,
// //                             initialDate: DateTime.now(),
// //                             firstDate: DateTime(1900),
// //                             lastDate: DateTime(2100)))!;

// //                         bdayController.text = date.toString();

// //                         if (date != null) {
// //                           print(date);
// //                           String formattedDate =
// //                               DateFormat('dd-MM-yyyy').format(date);
// //                           print(formattedDate);
// //                           setState(() {
// //                             bdayController.text =
// //                                 formattedDate; //set output date to TextField value.
// //                           });
// //                         } else {
// //                           print("Date is not selected");
// //                         }
// //                       },
// //                       validator: (value) {
// //                         if (value!.isEmpty || value.length < 1) {
// //                           return 'Choose Date';
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(
// //                 height: 15,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 30),
// //                 child: Container(
// //                   child: Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text("Gender"),
// //                   ),
// //                 ),
// //               ),
// //               Container(
// //                 padding: const EdgeInsets.all(1.0),
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: <Widget>[
// //                     DropdownButton(
// //                       // Initial Value
// //                       value: genderDropdownValue,

// //                       // Down Arrow Icon
// //                       icon: const Icon(Icons.keyboard_arrow_down),

// //                       // Array list of items
// //                       items: genderitems.map((String items) {
// //                         return DropdownMenuItem(
// //                           value: items,
// //                           child: Text(items),
// //                         );
// //                       }).toList(),
// //                       // After selecting the desired option,it will
// //                       // change button value to selected value
// //                       onChanged: (String? newValue) {
// //                         genderDropdownValue = newValue!;
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               TextFormField(
// //                 decoration: InputDecoration(
// //                   labelText: 'Institution',
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter your institution';
// //                   }
// //                   return null;
// //                 },
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _institution = value.trim();
// //                   });
// //                 },
// //               ),
// //               const SizedBox(
// //                 height: 15,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 30),
// //                 child: Container(
// //                   child: Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: Text("Degree"),
// //                   ),
// //                 ),
// //               ),
// //               Container(
// //                 padding: const EdgeInsets.all(1.0),
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: <Widget>[
// //                     DropdownButton(
// //                       // Initial Value
// //                       value: degreeDropdownValue,

// //                       // Down Arrow Icon
// //                       icon: const Icon(Icons.keyboard_arrow_down),

// //                       // Array list of items
// //                       items: degreeitems.map((String items) {
// //                         return DropdownMenuItem(
// //                           value: items,
// //                           child: Text(items),
// //                         );
// //                       }).toList(),
// //                       // After selecting the desired option,it will
// //                       // change button value to selected value
// //                       onChanged: (String? newValue) {
// //                         degreeDropdownValue = newValue!;
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(
// //                 height: 5,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 30),
// //                 child: Container(),
// //               ),
// //               SizedBox(height: 16.0),
// //               GetBuilder(
// //                 init: AuthController(),
// //                 builder: (AuthController authController) {
// //                   return ElevatedButton(
// //                     onPressed: () async {
// //                       if (_formKey.currentState!.validate()) {
// //                         authController.register(
// //                           _firstName.trim(),
// //                           _lastName.trim(),
// //                           _email.trim(),
// //                           _password.trim(),
// //                           bdayController.text.trim(),
// //                           genderDropdownValue.trim(),
// //                           _institution.trim(),
// //                           degreeDropdownValue.trim(),
// //                         );
// //                       }
// //                       print('uploaded');
// //                     },
// //                     child: const Center(
// //                       child: Text(
// //                         'Sign up',
// //                         style: TextStyle(
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
