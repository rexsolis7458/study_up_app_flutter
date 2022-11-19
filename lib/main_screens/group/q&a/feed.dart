import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_up_app/main_screens/group/q&a/posting.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'commentModel.dart';
import 'list.dart';

class Qa extends StatefulWidget {
  @override
  _QaState createState() => _QaState();
}

class _QaState extends State<Qa> {
  final PostService _postService = PostService();
  QuerySnapshot? commentSnapshot;
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value:
          _postService.getPostsByUser(FirebaseAuth.instance.currentUser?.uid),
      initialData: [],
      child: Scaffold(
        body: ListQuestions(),
        
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Posting(),
                ),
              );
            }),
      ),
    );
  }
}

// class CommentTile extends StatefulWidget {
//   // final CommentModel commentModel;
//   // final int index;
//   // CommentTile({required this.commentModel, required this.index});
//   // CommentTile({required this.index});
//   @override
//   State<CommentTile> createState() => _CommentTileState();
// }

// class _CommentTileState extends State<CommentTile> {
//   String optionSelected = '';
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Text(
//             "ksh",
//             style: TextStyle(fontSize: 17, color: Colors.black87),
//           ),
//           SizedBox(
//             height: 12,
//           ),
//         ],
//       ),
//     );
//   }
// }
