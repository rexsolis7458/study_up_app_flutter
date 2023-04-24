import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:study_up_app/controller/auth_controller.dart';
import 'package:study_up_app/helper/const.dart';

import '../group/q&a/CommentPage.dart';
import '../group/q&a/PostCommentModel.dart';

class HomeTab extends GetWidget<AuthController> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference postsRef;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          toolbarHeight: 56.0,
          elevation: 0,
          title: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
                color: MainColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
        body: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: size.height * 0.4,
            child: Stack(
              children: <Widget>[
                // Text(
                //   'Study Up',
                //   style: const TextStyle(
                //     backgroundColor: MainColor,
                //     color: SecondaryColor,
                //     fontSize: 40,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Container(
                  height: size.height * 5 - 5,
                  decoration: BoxDecoration(
                    color: MainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: Container(
                //     margin: EdgeInsets.symmetric(horizontal: 16.0),
                //     height: 54,
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(20),
                //         boxShadow: [
                //           BoxShadow(
                //             offset: Offset(0, 1),
                //             blurRadius: 80,
                //             //color: whitewithOpacity(0,23),
                //           )
                //         ]),
                //     child: Column(
                //       children: [
                //         Column(
                //           children: <Widget>[
                //             Expanded(
                //               child: TextField(
                //                 onChanged: (value) {},
                //                 decoration: InputDecoration(
                //                   hintText: "Search",
                //                   hintStyle: TextStyle(
                //                       color: Colors.black.withOpacity(0.3)),
                //                   enabledBorder: InputBorder.none,
                //                   focusedBorder: InputBorder.none,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text('Stack of Q&A Just For You'),

          // StreamBuilder<QuerySnapshot>(
          //   stream: FirebaseFirestore.instance
          //       .collection('Post/${widget.group['groupName']}/posts')
          //       .snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: CircularProgressIndicator());
          //     }

          //     if (snapshot.hasError) {
          //       return Center(child: Text('Failed to load posts'));
          //     }

          //     final posts = snapshot.data!.docs
          //         .map((doc) => PostModel.fromFirestore(doc))
          //         .toList();
          SingleChildScrollView(
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                // ListView.builder(
                // itemCount: posts.length,
                // itemBuilder: (context, index) {
                // final post = posts[index];
                // List<String> upvotes = post.upvoters;
                // List<String> downvotes = post.downvoters;

                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 130,
                  // padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: BGColor,
                    // margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, right: 30),
                          width: double.infinity,
                          child: Text(
                            'jhhj',
                            // post.posterName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 5, right: 30),
                          width: double.infinity,
                          child: Text(
                            'jh',
                            // '     ${post.title}',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            'jhjh',
                            // post.content,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // IconButton(
                                //   onPressed: () =>
                                //       upvotePost(post.id),
                                //   icon:
                                //       const Icon(Icons.arrow_upward),
                                // ),
                                Text(
                                  'hjh',
                                  // '(${post.upvoters.length})',
                                ),
                                // IconButton(
                                //   onPressed: () =>
                                //       downvotePost(post.id),
                                //   icon: const Icon(
                                //       Icons.arrow_downward),
                                // ),
                                Text(
                                  'downvoters',
                                  // '(${post.downvoters.length})',
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: SizedBox(
                                    width: 180,
                                    height: 40,
                                    child: TextButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         CommentsPage(
                                        //             post: post),
                                        //   ),
                                        // );
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
                  ),
                )
              ])))
        ]));
  }
}
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // );

// }

//  child: const SizedBox(
//                         width: 350,
//                         height: 100,
//                         child: Text('My File'),
//                       ),
//  const Text(
//             'Study Up',
//             style: const TextStyle(
//               backgroundColor: MainColor,
//               color: SecondaryColor,
//               fontSize: 40,
//               fontWeight: FontWeight.bold,
//             ),
//           ),