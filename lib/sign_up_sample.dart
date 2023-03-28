import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'controller/auth_controller.dart';
import 'helper/const.dart';
import 'package:intl/intl.dart';
// class SignUpSamplePage extends StatefulWidget {
//   @override
//   _SignUpSamplePageState createState() => _SignUpSamplePageState();
// }

// class _SignUpSamplePageState extends State<SignUpSamplePage> {
//   final AuthController controller = Get.put(AuthController());

//   int? genderValue;
//   String dropdownvalue = 'Male';
//   var items = [
//     'Male',
//     'Female',
//     'Others',
//   ];
//   Future _selectDate() async {
//     DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: new DateTime.now(),
//         firstDate: new DateTime(2020),
//         lastDate: new DateTime(2030));
//     if (picked != null) ;
//     //  setState(
//     //    () => { data.registrationdate = picked.toString(),
//     //    intialdateval.text = picked.toString()
//     //    }
//     //  );
//   }

//   TextEditingController bdayController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth _auth = FirebaseAuth.instance;
//     AuthController authController = AuthController.instance;

//     TextEditingController firstNameController = TextEditingController();
//     TextEditingController lastNameController = TextEditingController();
//     TextEditingController emailController = TextEditingController();
//     TextEditingController passwordController = TextEditingController();

//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: MainColor,
//         appBar: AppBar(
//           backgroundColor: MainColor,
//           centerTitle: true,
//           elevation: 0,
//           title: const Text(
//             'Register',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const CircleAvatar(
//                 backgroundImage: AssetImage('assets/logo.png'),
//                 radius: 40,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text('StudyUp'),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                 child: TextField(
//                   controller: firstNameController,
//                   decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(width: 3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     hintText: "First Name",
//                     hintStyle: TextStyle(color: Colors.grey[350]),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                 child: TextField(
//                   controller: lastNameController,
//                   decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(width: 3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     hintText: "Last Name",
//                     hintStyle: TextStyle(color: Colors.grey[350]),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                 child: TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(width: 3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     hintText: "Email",
//                     hintStyle: TextStyle(color: Colors.grey[350]),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
//                 child: TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(width: 3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     hintText: "Password",
//                     hintStyle: TextStyle(color: Colors.grey[350]),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30),
//                 child: Container(
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text("Date of Birth"),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30),
//                 child: Container(
//                   child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: InkWell(
//                         onTap: () {
//                           _selectDate(); // Call Function that has showDatePicker()
//                         },
//                         child: IgnorePointer(
//                           child: TextFormField(
//                             // focusNode: _focusNode,
//                             keyboardType: TextInputType.phone,
//                             autocorrect: false,
//                             controller: bdayController,
//                             // onSaved: (value) {
//                             //   data.registrationdate = value;
//                             // },
//                             onTap: () {
//                               // _selectDate();
//                               FocusScope.of(context)
//                                   .requestFocus(new FocusNode());
//                             },

//                             maxLines: 1,
//                             //initialValue: 'Aseem Wangoo',
//                             validator: (value) {
//                               if (value!.isEmpty || value.length < 1) {
//                                 return 'Choose Date';
//                               }
//                             },
//                             decoration: InputDecoration(
//                               labelText: 'Date of Birth',
//                               //filled: true,
//                               icon: const Icon(Icons.calendar_today),
//                               labelStyle: TextStyle(
//                                   decorationStyle: TextDecorationStyle.solid),
//                             ),
//                           ),
//                         ),
//                       )),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30),
//                 child: Container(
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text("Gender"),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(1.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     DropdownButton(
//                       // Initial Value
//                       value: dropdownvalue,

//                       // Down Arrow Icon
//                       icon: const Icon(Icons.keyboard_arrow_down),

//                       // Array list of items
//                       items: items.map((String items) {
//                         return DropdownMenuItem(
//                           value: items,
//                           child: Text(items),
//                         );
//                       }).toList(),
//                       // After selecting the desired option,it will
//                       // change button value to selected value
//                       onChanged: (String? newValue) {
//                         dropdownvalue = newValue!;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30),
//                 child: Container(),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   authController.register(
//                     firstNameController.text.trim(),
//                     lastNameController.text.trim(),
//                     emailController.text.trim(),
//                     passwordController.text.trim(),
//                     bdayController as String,
//                     genderValue as String,
//                   );
//                 },
//                 child: Container(
//                   width: 150,
//                   height: 40,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: ButtonColor),
//                   child: const Center(
//                     child: Text(
//                       "Sign Up",
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               RichText(
//                   text: TextSpan(
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () => Get.back(),
//                       text: "Have an account already?",
//                       style: TextStyle(fontSize: 20, color: Colors.black54))),
//               const SizedBox(
//                 height: 0.16,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class SignupPageSample extends StatefulWidget {
  @override
  _SignupPageSampleState createState() => _SignupPageSampleState();
}

class _SignupPageSampleState extends State<SignupPageSample> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;
  String data = '';
  late String _birthdate = '';
  late String _gender;

  AuthController authController = AuthController.instance;

  int? genderValue;
  String dropdownvalue = 'Male';
  var items = [
    'Male',
    'Female',
    'Others',
  ];

  TextEditingController bdayController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _firstName = value.trim();
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _lastName = value.trim();
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Date of Birth"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: bdayController,
                      decoration: InputDecoration(
                        labelText: "Date of Birth",
                        hintText: "Date of Birth",
                      ),
                      onTap: () async {
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100)))!;

                        bdayController.text = date.toString();

                        if (date != null) {
                          print(date);
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(date);
                          print(formattedDate);
                          setState(() {
                            bdayController.text =
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
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Gender"),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                      // Initial Value
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        dropdownvalue = newValue!;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(),
              ),
              SizedBox(height: 16.0),
              GetBuilder(
                init: AuthController(),
                builder: (AuthController authController) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        authController.register(
                          _firstName.trim(),
                          _lastName.trim(),
                          _email.trim(),
                          _password.trim(),
                          bdayController.text.trim(),
                          dropdownvalue.trim(),
                        );
                      }
                      print('uploaded');
                    },
                    child: const Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
