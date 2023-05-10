import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/quiz/create_quiz.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz.dart';
import 'package:study_up_app/services/database.dart';

import '../../../helper/const.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  late String question = "",
      option1 = "",
      option2 = "",
      option3 = "",
      option4 = "";

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  List<Widget> test = [];

  Future<void> addQuestionData(
      String quizId, Map<String, dynamic> questionData) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection('QNA')
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadQuestionData() async {
    // if (_formKey.currentState!.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //   });

    Map<String, String> questionMap = {
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
    };
    await addQuestionData(widget.quizId, questionMap).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void addQuestion() {
    setState(() {
      test.add(addQuestionTile());
    });
  }

  Widget addQuestionTile() {
    return _isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Form(
            // key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Question can't be empty" : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "Question",
                    ),
                    onChanged: (val) {
                      question = val;
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Option 1 can't be empty" : null,
                    decoration: InputDecoration(
                      hintText: "Option 1 (Correct Answer)",
                    ),
                    onChanged: (val) {
                      option1 = val;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Option 2 can't be empty" : null,
                    decoration: InputDecoration(
                      hintText: "Option 2 ",
                    ),
                    onChanged: (val) {
                      option2 = val;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Option 3 can't be empty" : null,
                    decoration: InputDecoration(
                      hintText: "Option 3",
                    ),
                    onChanged: (val) {
                      option3 = val;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Option 4  can't be empty" : null,
                    decoration: InputDecoration(
                      hintText: "Option 4 ",
                    ),
                    onChanged: (val) {
                      option4 = val;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FloatingActionButton.extended(
          onPressed: addQuestion,
          label: Text('Add Question'),
          heroTag: null,
        ),
        FloatingActionButton.extended(
          onPressed: () async {
            uploadQuestionData();
          },
          label: Text('Submit'),
        ),
      ]),
      appBar: AppBar(
        backgroundColor: MainColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'StudyUp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: test.length,
        itemBuilder: (context, index) {
          return test[index];
        },
      ),
    );
  }
}
