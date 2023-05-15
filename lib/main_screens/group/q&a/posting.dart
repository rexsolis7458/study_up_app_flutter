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

  @override
  void initState() {
    super.initState();
    getSubjectsFromFirestore();
  }

  Future<void> getSubjectsFromFirestore() async {
  try {
    QuerySnapshot<Map<String, dynamic>> groupDocs = await FirebaseFirestore.instance
        .collection('groups')
        .where('groupId', isEqualTo: widget.group.id)
        .get();
    if (groupDocs.docs.isNotEmpty) {
      setState(() {
        _subjectItems = List<String>.from(groupDocs.docs.first['Subjects']);
      });
    } else {
      print('No group found with id ${widget.group.id}');
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
  child: Row(
    children: <Widget>[
      SizedBox(
        width: 300, // adjust the width as needed
        child: DropdownButton<String>(
          value: _selectedSubject,
          hint: Text('Select a subject'),
          isExpanded: true, // ensures that the dropdown button fills its parent's width
          onChanged: (String? newValue) {
            setState(() {
              _selectedSubject = newValue;
            });
          },
          items: _subjectItems.map((String subject) {
            return DropdownMenuItem<String>(
              value: subject,
              child: Text(
                subject,
                overflow: TextOverflow.ellipsis, // add ellipsis when text overflows
                maxLines: 1, // restrict text to a single line
              ),
            );
          }).toList(),
        ),
      ),
    ],
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
