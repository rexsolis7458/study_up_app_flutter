import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/quiz/addQuestion.dart';
import '../../../helper/const.dart';

class QuizForm extends StatefulWidget {
  final DocumentSnapshot group;
  const QuizForm(this.group, {super.key});

  @override
  State<QuizForm> createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  final _formKey = GlobalKey<FormState>();
  // late String quizImgurl, quizTitle, quizDescription, quizId;
  late String quizTitle, quizDescription, quizId;

  bool _isLoading = false;

  Future<void> addQuizData(String quizId, Map<String, dynamic> quizData) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  createQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      quizId = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        // 'quizImgurl': quizImgurl,
        'groupId': widget.group.id,
        'quizId': quizId,
        'quizTitle': quizTitle,
        'quizDescription': quizDescription
      };

      await addQuizData(quizId, quizMap).then(
        (value) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var buttonColor = ButtonColor;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        title: Text(
          'StudyUp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
      child:_isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                // margin: EdgeInsets.only(bottom: 8, top: 10),
                color: BGColor,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        createQuiz();
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            "Create Quiz",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ButtonColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
