import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/q&a/CommentPage.dart';
import 'package:study_up_app/main_screens/group/q&a/PostCommentModel.dart';
import 'package:study_up_app/models/group.dart';

class AllPost extends StatefulWidget {
  const AllPost({super.key});

  @override
  State<AllPost> createState() => _AllPostState();
}

class _AllPostState extends State<AllPost> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  int? subjectValue;
  String? _selectedSubject = '';
  List<String> _subjectItems = [];

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

  @override
  void initState() {
    super.initState();
    getSubjectsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection('groups')
            .where('Subjects', arrayContains: _selectedSubject)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Failed to load posts'));
            }

            final groups = snapshot.data!.docs
                .map((doc) => GroupModel.fromDocumentSnapshot(doc))
                .toList();

            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  DropdownButton(
                    value: _selectedSubject == '' ? null : _selectedSubject,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: true, // set this to true to remove search box
                    items: _subjectItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSubject = newValue!;
                        subjectValue = _subjectItems.indexOf(newValue);
                      });
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(groups.length, (index) {
                          final group = groups[index];

                          return StreamBuilder<QuerySnapshot>(
                              stream: firestore
                                  .collectionGroup('posts')
                                  .where('groupId', isEqualTo: group.groupId)
                                  .orderBy('createdAt')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                // if (snapshot.connectionState == ConnectionState.active) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return const Center(
                                      child: Text('Failed to load posts'));
                                }

                                final posts = snapshot.data!.docs
                                    .map((doc) => PostModel.fromFirestore(doc))
                                    .toList();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    final post = posts[index];

                                    return Card(
                                      color: BGColor,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5, right: 30),
                                            width: double.infinity,
                                            child: Text(
                                              post.posterName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              '     ${post.title}',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              post.content,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommentsPage(
                                                                  post: post),
                                                        ),
                                                      );
                                                    },
                                                    child:
                                                        const Text('Comment'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              });
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Handle other ConnectionState values (e.g. waiting, done)
            return Container();
          }
        },
      ),
    );
  }
}
