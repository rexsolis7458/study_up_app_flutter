// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:study_up_app/main_screens/group/quiz/create_quiz.dart';
// import 'package:study_up_app/main_screens/group/quiz/quiz.dart';
// import 'package:study_up_app/services/database.dart';

// import '../../../helper/const.dart';

// class AddQuestion extends StatefulWidget {
//   final String quizId;
//   final String items;
//   AddQuestion(this.quizId, this.items);

//   @override
//   State<AddQuestion> createState() => _AddQuestionState();
// }

// class _AddQuestionState extends State<AddQuestion> {
//   final _formKey = GlobalKey<FormState>();
//   late String question, option1, option2, option3, option4;

//   bool _isLoading = false;

//   int numForms = 1;

//   Future<void> addQuestionData(String quizId, Map<String, dynamic> questionData,
//       Function() callback) async {
//     await FirebaseFirestore.instance
//         .collection("Quiz")
//         .doc(quizId)
//         .collection('QNA')
//         .add(questionData)
//         .then((value) => callback())
//         .catchError((e) {
//       print(e.toString());
//     });
//   }

//   uploadQuestionData() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       Map<String, String> questionMap = {
//         'question': question,
//         'option1': option1,
//         'option2': option2,
//         'option3': option3,
//         'option4': option4,
//       };
//       await addQuestionData(widget.quizId, questionMap, () {
//         setState(() {
//           _isLoading = false;
//           numForms++;
//           question = '';
//           option1 = '';
//           option2 = '';
//           option3 = '';
//           option4 = '';
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> formList = [];
//     for (int i = 0; i < numForms; i++) {
//       formList.add(Form(
//         key: GlobalKey<FormState>(),
//         child: Container(
//           color: BGColor,
//           padding: EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 40,
//               ),
//               TextFormField(
//                 validator: (val) =>
//                     val!.isEmpty ? "Question can't be empty" : null,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 3),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   hintText: "Question",
//                 ),
//                 onChanged: (val) {
//                   question = val;
//                 },
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               TextFormField(
//                 validator: (val) =>
//                     val!.isEmpty ? "Option 1 can't be empty" : null,
//                 decoration: InputDecoration(
//                   hintText: "Option 1 (Correct Answer)",
//                 ),
//                 onChanged: (val) {
//                   option1 = val;
//                 },
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 validator: (val) =>
//                     val!.isEmpty ? "Option 2 can't be empty" : null,
//                 decoration: InputDecoration(
//                   hintText: "Option 2 ",
//                 ),
//                 onChanged: (val) {
//                   option2 = val;
//                 },
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 validator: (val) =>
//                     val!.isEmpty ? "Option 3 can't be empty" : null,
//                 decoration: InputDecoration(
//                   hintText: "Option 3",
//                 ),
//                 onChanged: (val) {
//                   option3 = val;
//                 },
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 validator: (val) =>
//                     val!.isEmpty ? "Option 4  can't be empty" : null,
//                 decoration: InputDecoration(
//                   hintText: "Option 4 ",
//                 ),
//                 onChanged: (val) {
//                   option4 = val;
//                 },
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: ButtonColor,
//                     ),
//                     onPressed: () {
//                       uploadQuestionData();
//                     },
//                     child: const Text("Add Question"),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: ButtonColor,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Submit"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ));
//     }
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColor,
//         centerTitle: true,
//         elevation: 0,
//         title: Text(
//           'StudyUp',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: formList,
//         ),
//       ),
//     );
//   }
// }
