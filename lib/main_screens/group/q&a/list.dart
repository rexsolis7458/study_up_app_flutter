// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:study_up_app/main_screens/group/q&a/commentModel.dart';

// class ListQuestions extends StatefulWidget {
//   @override
//   _ListQuestionsState createState() => _ListQuestionsState();
// }

// class _ListQuestionsState extends State<ListQuestions> {
//   @override
//   Widget build(BuildContext context) {
//     final posts = Provider.of<List<CommentModel>>(context);
//     return ListView.builder(
//       itemCount: posts.length,
//       itemBuilder: (context, index) {
//         final post = posts[index];
//         return ListTile(
//           title: Text(post.creator),
//           subtitle: Text(post.question),
//         );
//       },
//     );
//   }
// }
