import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'rateUser.dart';
import 'PostCommentModel.dart';
import 'package:intl/src/intl/date_format.dart';
import 'dart:math' as math;

class CommentsPage extends StatefulWidget {
  final PostModel post;

  const CommentsPage({Key? key, required this.post}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();

  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.post.id)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Failed to load comments'));
                }

                print('Comments snapshot data: ${snapshot.data}');

                try {
                  final comments = snapshot.data!.docs
                      .map((doc) => CommentModel.fromFirestore(doc))
                      .toList();

                  print('Parsed comments: $comments');

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      DateTime created = comment.createdAt.toDate();

                      String createdTime =
                          "${dateTime.month}-${dateTime.day}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
                      return ListTile(
                        title: Text(comment.content),
                        subtitle: Text(
                          comment.commenterName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(createdTime),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RateUser();
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                } catch (e, stackTrace) {
                  print('Error: $e');
                  print('Stack trace: $stackTrace');
                  return Center(child: Text('An error occurred'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get();
                    final commenterName =
                        userDoc['firstname'] + ' ' + userDoc['lastname'];
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.post.id)
                        .collection('comments')
                        .add(CommentModel(
                          content: _commentController.text.trim(),
                          authorId: FirebaseAuth.instance.currentUser!.uid,
                          commenterName: commenterName,
                          createdAt: Timestamp.now(),
                          postId: '',
                        ).toFirestore())
                        .then((value) {
                      _commentController.clear();
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add comment')));
                    });
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
