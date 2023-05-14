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
  List<String> _subjectItems = [];
  String? _selectedSubject;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> getSubjectsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Subjects')
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _subjectItems = List<String>.from(querySnapshot.docs.first['items']);
        });
      } else {
        print('No documents found in the collection');
      }
    } catch (error) {
      print("Error fetching subjects collection: $error");
    }
  }

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
      'subject': _selectedSubject,
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
            Container(
              padding: const EdgeInsets.only(left: 15, top: 5, right: 30),
              alignment: Alignment.topLeft,
              child: DropdownButton<String>(
                value: _selectedSubject,
                hint: Text('Select an option'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
                items: _subjectItems.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
              ),
            ),
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
