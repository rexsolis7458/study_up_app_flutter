// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:random_string/random_string.dart';
// import 'package:study_up_app/main_screens/group/q&a/posting.dart';
// import '../../../helper/const.dart';
// import '../../../services/database.dart';
// import '../../../services/db.dart';
// import '../../../services/post.dart';
// import 'commentModel.dart';
// import 'feed.dart';
// import 'list.dart';

// class Replies extends StatefulWidget {
//   Replies({Key? key}) : super(key: key);

//   @override
//   _RepliesState createState() => _RepliesState();
// }

// class _RepliesState extends State<Replies> {
//   PostService _postService = PostService();
//   String text = '';
//   TextEditingController _textController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     PostModel args = ModalRoute.of(context).settings.arguments;
//     return FutureProvider.value(
//         value: _postService.getReplies(args),
//         initialData: [],
//         child: Container(
//           child: Scaffold(
//             body: Container(
//               child: Column(
//                 children: [
//                   Expanded(child: ListPosts(args)),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Form(
//                             child: TextFormField(
//                           controller: _textController,
//                           onChanged: (val) {
//                             setState(() {
//                               text = val;
//                             });
//                           },
//                         )),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         FlatButton(
//                             textColor: Colors.white,
//                             color: Colors.blue,
//                             onPressed: () async {
//                               await _postService.reply(args, text);
//                               _textController.text = '';
//                               setState(() {
//                                 text = '';
//                               });
//                             },
//                             child: Text("Reply"))
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }