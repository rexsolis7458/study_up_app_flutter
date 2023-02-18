// import 'dart:html';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:random_string/random_string.dart';
// import 'package:study_up_app/main_screens/group/q&a/posting.dart';
// import 'package:study_up_app/models/post.dart';
// import '../../../controller/auth_controller.dart';
// import '../../../controller/userController.dart';
// import '../../../helper/const.dart';
// import '../../../services/database.dart';
// import 'commentModel.dart';
// import 'feed.dart';
// import 'list.dart';

// class Comment extends StatefulWidget {

//   @override
  
//   _CommentState createState() => _CommentState();
// }

// class _CommentState extends State<Comment> {
//     late String commentBody, commentId, userId, timeStamp;
//   addComment() {
//     Map<String, dynamic> data = Comment(
//             commentBody: _controller.value.text,
//             commentId: "na",
//             userId: _user.uid,
//             timeStamp: DateTime.now().millisecondsSinceEpoch.toString())
//         .toMap();

//     _controller.clear();
//     _commentRef.add(data).then((docRef) {
//       _commentRef
//           .document(docRef.documentID)
//           .updateData({"comment_id": docRef.documentID});

//       incrementComment(widget.story.storyId);
//     });
//   }

//   incrementComment(String docRef) async {
//     //use transaction on the fire store instance to prevent race condition
//     FirebaseFirestore.instance.runTransaction((transaction) async {
//       //get a document snapshot at the current position
//       DocumentSnapshot snapshot = await transaction
//           .get(FirebaseFirestore.instance.collection("all_post").doc(docRef));

//       //increment comment count for the story
//       await transaction.update(snapshot.reference,
//           {"comment_count": snapshot.data['comment_count'] + 1});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           elevation: 0,
//           iconTheme: IconThemeData(
//             color: Colors.black54,
//           ),
//           actions: <Widget>[
//             // TextButton(
//             //   onPressed: () async {
//             //     createReply();
//             //     Navigator.pop(context);
//             //   },
//             //   child: Text(
//             //     'Post',
//             //     style: TextStyle(color: Colors.black54),
//             //   ),
//             // ),
//           ],
//         ),
//         body: StreamBuilder(
//   stream: FirebaseFirestore.instance.collection("all_post").doc(document.data.documents[index]["post_id"]).snapshots(), 
//   builder: (BuildContext context,
//  AsyncSnapshot snapshot) {
//   return Padding(
//            padding: const EdgeInsets.only(right: 20.0),
//        child: Row(
//                     children: <Widget>[
//                            Icon(Icons.chat_bubble_outline,
//                          color: Colors.grey, size: 18.0),
//                             Text(      snapshot.data == null
//                                                   ? "0"
//                                                   : snapshot
//                                                       .data["comment_count"]
//                                                       .toString(),
//                                               style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   )),
//       );
    
//   }
// }
