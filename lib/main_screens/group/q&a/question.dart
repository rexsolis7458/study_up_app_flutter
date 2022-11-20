import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/q&a/posting.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'commentModel.dart';
import 'feed.dart';
import 'list.dart';

class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final _formKey = GlobalKey<FormState>();
  // late String quizImgurl, quizTitle, quizDescription, quizId;
  late String question, questionId;

  QuestionService questionService = new QuestionService();

  bool _isLoading = false;

  createQuestion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      questionId = randomAlphaNumeric(16);

      Map<String, String> questionMap = {
        // 'quizImgurl': quizImgurl,
        'questionId': questionId,
        'question': question,
      };

      await questionService.addQuestionData(questionId, questionMap).then(
        (value) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Feed()));
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              createQuestion();
              Navigator.pop(context);
            },
            child: Text(
              'Post',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                color: BGColor,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      validator: (val) => val!.isEmpty ? " " : null,
                      decoration: InputDecoration(
                        hintText: "Got a question? Ask right away!",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CommentTile extends StatefulWidget {
  // final CommentModel commentModel;
  // final int index;
  // CommentTile({required this.commentModel, required this.index});
  // CommentTile({required this.index});
  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  String optionSelected = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "ksh",
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
