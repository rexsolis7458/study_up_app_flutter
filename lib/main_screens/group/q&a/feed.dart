import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_up_app/main_screens/group/q&a/posting.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'commentModel.dart';
import 'list.dart';
import 'question.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Stream? quizStream;

  DatabaseService databaseService = new DatabaseService();

  Widget commentList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return CommentTile(
                      // imgUrl: snapshot.data.doc[index].data['quizImgurl'],
                      comment: snapshot.data.docs[index].data()['comment'],
                      commentId: snapshot.data.docs[index].data()['commentId'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: commentList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Question(),
              ),
            );
          }),
    );
  }
}

class CommentTile extends StatelessWidget {
  // final String imgUrl;
  final String comment;
  final String commentId;

  // QuizTile({required this.imgUrl, required this.title, required this.desc});
  CommentTile({required this.comment, required this.commentId});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: 150,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            // child: Image.network(
            //   imgUrl,
            //   width: MediaQuery.of(context).size.width - 48,
            //   fit: BoxFit.cover,
            // ),
          ),
          Container(
            // color: ButtonColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: BGColor,
            ),
            // color: Colors.black26,
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                comment,
                style: TextStyle(
                    color: MainColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              // Text(
              //   desc,
              //   style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 14,
              //       fontWeight: FontWeight.w400),
              // )
            ]),
          )
        ],
      ),
    );
  }
}
