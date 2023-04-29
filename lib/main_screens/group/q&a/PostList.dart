import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_up_app/main_screens/group/q&a/CommentPage.dart';
import 'package:study_up_app/main_screens/group/q&a/Posting.dart';
import '../../../helper/const.dart';
import 'PostCommentModel.dart';

class PostList extends StatefulWidget {
  final DocumentSnapshot group;

  PostList(this.group, {Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference postsRef;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    postsRef = firestore.collection('Post/${widget.group['groupName']}/posts');
  }

  Future<void> upvotePost(String postId) async {
    DocumentReference postDoc = postsRef.doc(postId);
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postDoc);
      if (postSnapshot.exists) {
        PostModel post = PostModel.fromFirestore(postSnapshot);
        if (!post.upvoters.contains(auth.currentUser!.uid)) {
          post.upvoters.add(auth.currentUser!.uid);
          if (post.downvoters.contains(auth.currentUser!.uid)) {
            post.downvoters.remove(auth.currentUser!.uid);
          }
          await transaction.update(postDoc, post.toFirestore());
        }
      }
    });
  }

  Future<void> downvotePost(String postId) async {
    DocumentReference postDoc = postsRef.doc(postId);
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postDoc);
      if (postSnapshot.exists) {
        PostModel post = PostModel.fromFirestore(postSnapshot);
        if (!post.downvoters.contains(auth.currentUser!.uid)) {
          post.downvoters.add(auth.currentUser!.uid);
          if (post.upvoters.contains(auth.currentUser!.uid)) {
            post.upvoters.remove(auth.currentUser!.uid);
          }
          await transaction.update(postDoc, post.toFirestore());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body:
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child:
            StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Post/${widget.group['groupName']}/posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Failed to load posts'));
            }

            final posts = snapshot.data!.docs
                .map((doc) => PostModel.fromFirestore(doc))
                .toList();

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                List<String> upvotes = post.upvoters;
                List<String> downvotes = post.downvoters;

                return Card(
                  color: BGColor,
                  // margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, right: 30),
                        width: double.infinity,
                        child: Text(
                          post.posterName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          '     ${post.title}',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          post.content,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => upvotePost(post.id),
                                icon: const Icon(Icons.arrow_upward),
                              ),
                              Text('(${post.upvoters.length})'),
                              IconButton(
                                onPressed: () => downvotePost(post.id),
                                icon: const Icon(Icons.arrow_downward),
                              ),
                              Text('(${post.downvoters.length})'),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: SizedBox(
                                  width: 180,
                                  height: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CommentsPage(post: post),
                                        ),
                                      );
                                    },
                                    child: const Text('Comment'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPost(widget.group),
              ),
            );
          },
        ),
      );
}
