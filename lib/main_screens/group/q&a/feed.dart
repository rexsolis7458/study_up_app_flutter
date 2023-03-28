import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:study_up_app/main_screens/group/q&a/Posting.dart';
import 'package:study_up_app/main_screens/group/q&a/replies.dart';
import 'package:study_up_app/main_screens/group/q&a/reply.dart';
import '../../../controller/userController.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'question.dart';
import 'package:study_up_app/controller/auth_controller.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Stream? commentStream;

  CommentService commentService = new CommentService();

  Widget commentList() {
    return Container(
      child: StreamBuilder(
        stream: commentStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return CommentTile(
                      // imgUrl: snapshot.data.doc[index].data['quizImgurl'],
                      comment: snapshot.data.docs[index]
                          .data()['commentDescription'],
                      comId: snapshot.data.docs[index].data()['commentId'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    commentService.getCommentsData().then((val) {
      setState(() {
        commentStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, top: 10),
      child: Scaffold(
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
          },
        ),
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  //final String imgUrl;
  final String comment;
  final String comId;

  // QuizTile({required this.imgUrl, required this.title, required this.desc});
  CommentTile({required this.comment, required this.comId});

  @override
  Widget build(BuildContext context) =>
      GetX<UserController>(initState: (_) async {
        Get.find<UserController>().user =
            await Database().getUser(Get.find<AuthController>().reference.id);
      }, builder: (_) {
        if (_.user.id != null) {
          return SingleChildScrollView(
              child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // child: Image.network(
                      //   imgUrl,
                      //   width: MediaQuery.of(context).size.width - 48,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.only(left: 30, bottom: 11, top: 11, right: 15),
                  //   decoration: BoxDecoration(
                  //     // borderRadius: BorderRadius.circular(8),
                  //     color: BGColor,
                  //   ),
                  //   // color: Colors.black26,
                  //   alignment: Alignment.center,
                  //   child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         // ClipRRect(
                  //         //   borderRadius: BorderRadius.circular(8),
                  //         //   child: Image.network(
                  //         //     imgUrl,
                  //         //     width: MediaQuery.of(context).size.width - 48,
                  //         //     fit: BoxFit.cover,
                  //         //   ),
                  //         // ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_.user.email}',
                              style: TextStyle(
                                  color: MainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            comment,
                            // style: TextStyle(
                            //     color: MainColor,
                            //     fontSize: 17,
                            //     fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: new Icon(
                                  Icons.thumb_up_alt_outlined,
                                ),
                                onPressed: () => null),
                            IconButton(
                              icon: new Icon(
                                Icons.chat_bubble_outline,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => Reply()
                                        // CommentTile(
                                        //       comId: '',
                                        //       comment: '',
                                        //     ),
                                        ));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ));

          // const SizedBox(
          //   height: 6,
          // ),
          // Text(
          //   desc,
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 14,
          //       fontWeight: FontWeight.w400),
          // )
        } else {
          return const Text(
            'loading.....',
            textAlign: TextAlign.center,
          );
        }
      });
}
