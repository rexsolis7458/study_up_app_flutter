import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostPost extends StatefulWidget {
  final DocumentSnapshot group;

  PostPost(this.group);

  @override
  _PostPostState createState() => _PostPostState();
}

class _PostPostState extends State<PostPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _addPost() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final posterName = userDoc['firstname'] + ' ' + userDoc['lastname'];

    FirebaseFirestore.instance
        .collection('Post/${widget.group['groupName']}/posts')
        .add({
      'posterName': posterName,
      'groupId': widget.group.id,
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'authorId': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': Timestamp.now(),
    }).then((value) {
      _titleController.clear();
      _contentController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post added')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add post')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post to Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addPost,
              child: Text('Post'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
