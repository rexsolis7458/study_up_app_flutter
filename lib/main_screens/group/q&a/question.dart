import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/q&a/Posting.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'feed.dart';
import 'list.dart';

class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final _qFormKey = GlobalKey<FormState>();
  // late String quizImgurl, quizTitle, quizDescription, quizId;
  late String commentDescription, commentId;

  CommentService commentService = new CommentService();

  bool _isLoading = false;

  createComment() async {
    if (_qFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      commentId = randomAlphaNumeric(16);

      Map<String, String> commentMap = {
        // 'quizImgurl': quizImgurl,
        'commentId': commentId,
        'commentDescription': commentDescription
      };

      await commentService.addCommentData(commentId, commentMap).then(
        (value) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
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
              createComment();
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
              key: _qFormKey,
              child: Container(
                color: BGColor,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      validator: (val) => val!.isEmpty
                          ? "Got a question? Ask right away!"
                          : null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 30, bottom: 11, top: 11, right: 15),
                        hintText: "Got a question? Ask right away!",
                      ),
                      onChanged: (val) {
                        commentDescription = val;
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
