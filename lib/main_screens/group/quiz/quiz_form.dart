import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/quiz/addQuestion.dart';
import 'package:study_up_app/services/database.dart';

import '../../../helper/const.dart';

class QuizForm extends StatefulWidget {
  const QuizForm({super.key});

  @override
  State<QuizForm> createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  final _formKey = GlobalKey<FormState>();
  // late String quizImgurl, quizTitle, quizDescription, quizId;
  late String quizTitle, quizDescription, quizId;

  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  createQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      quizId = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        // 'quizImgurl': quizImgurl,
        'quizId': quizId,
        'quizTitle': quizTitle,
        'quizDescription': quizDescription
      };

      await databaseService.addQuizData(quizId, quizMap).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var buttonColor = ButtonColor;
    return Scaffold(
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // TextFormField(
                    //   validator: (val) =>
                    //       val!.isEmpty ? "Quiz Image Url can't be empty" : null,
                    //   decoration: InputDecoration(
                    //     hintText: "Quiz Image Url",
                    //   ),
                    //   onChanged: (val) {
                    //     quizImgurl = val;
                    //   },
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Quiz Title can't be empty" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Title",
                      ),
                      onChanged: (val) {
                        quizTitle = val;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty
                          ? "Quiz Description can't be empty"
                          : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Description",
                      ),
                      onChanged: (val) {
                        quizDescription = val;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        createQuiz();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuestion(quizId),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ButtonColor),
                        child: Center(
                          child: Text(
                            "Create Quiz",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}