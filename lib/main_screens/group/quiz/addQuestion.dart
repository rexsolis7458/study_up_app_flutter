import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/quiz/create_quiz.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz.dart';
import 'package:study_up_app/services/database.dart';

import '../../../helper/const.dart';
import 'question_model.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  List<QuestionModel> questionModel = [];

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
    setState(() {
      _isLoading = true;
    });

    for (int i = 0; i < questionModel.length; i++) {
      Map<String, String> questionMap = {
        'question': questionModel[i].question,
        'option1': questionModel[i].option1,
        'option2': questionModel[i].option2,
        'option3': questionModel[i].option3,
        'option4': questionModel[i].option4,
      };
      await addQuestionData(widget.quizId, questionMap).then(
        (value) {
          setState(() {
            _isLoading = false;

            // Navigator.of(context, rootNavigator: true).pop();
          });
          Navigator.pop(context);
        },
      );
    }
  }

  int counter = 0;
  String onchangeval = "";
  void addQuestion() {
    setState(() {
      final payload = QuestionModel(
          question: " ",
          option1: " ",
          option2: " ",
          option3: " ",
          option4: " ",
          answered: true,
          correctOption: '');
      questionModel.add(payload);
      test.add(addQuestionTile(counter));
      counter += 1;
    });
  }

  Widget addQuestionTile(int counter) {
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
                    onChanged: (value) {
                      setState(() {
                        onchangeval = value;
                      });
                      questionModel[counter].question = onchangeval;
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
                    onChanged: (value) {
                      setState(() {
                        onchangeval = value;
                      });
                      questionModel[counter].option1 = onchangeval;
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
                    onChanged: (value) {
                      setState(() {
                        onchangeval = value;
                      });
                      questionModel[counter].option2 = onchangeval;
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
                    onChanged: (value) {
                      setState(() {
                        onchangeval = value;
                      });
                      questionModel[counter].option3 = onchangeval;
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
                    onChanged: (value) {
                      setState(() {
                        onchangeval = value;
                      });
                      questionModel[counter].option4 = onchangeval;
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
