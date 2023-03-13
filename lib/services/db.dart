// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../main_screens/group/q&a/commentModel.dart';
// import '../models/post.dart';
// import 'package:study_up_app/controller/userController.dart';
// import 'package:quiver/iterables.dart';

// questions and answers
// class PostService {
//    List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
//           return snapshot.docs.map((doc) {
//       return PostModel(
//         id: doc.id,
//         text:doc.data() ['text'] ?? '',
//         creator: doc.data()['creator'] ?? '',
//         timestamp: doc.data()['timestamp'] ?? 0, 
        
//       );
//     }).toList();
//   }
//       Future savePost(question) async {
//     await FirebaseFirestore.instance.collection("Question").add({
//       'question': question,
//       'creator': FirebaseAuth.instance.currentUser?.uid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
//    Stream<List<PostModel>> getPostsByUser(uid) {
//     return FirebaseFirestore.instance
//         .collection("Question")
//         .where('creator', isEqualTo: uid)
//         .snapshots()
//         .map(_postListFromSnapshot);
//   }



//  PostModel? _postFromSnapshot(DocumentSnapshot snapshot) {
//     return snapshot.exists
//         ? PostModel(
//             id: snapshot.id,
//             question: 'question',
//             creator: 'creator',
//             originalId: 'originalId',

//           )
//         : null;
//   }



//   Future reply(PostModel post, String question) async {
//     if (question == '') {
//       return;
//     }
//     await post.ref.collection("replies").add({
//       'question': question,
//       'creator': FirebaseAuth.instance.currentUser?.uid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<PostModel?> getPostById(String id) async {
//     DocumentSnapshot postSnap =
//         await FirebaseFirestore.instance.collection("Question").doc(id).get();

//     return _postFromSnapshot(postSnap);
//   }

 
//   Future<List<PostModel>> getReplies(PostModel question) async {
//     QuerySnapshot querySnapshot =
//         await question.ref.collection("replies").get();

//     return _postListFromSnapshot(querySnapshot);
//   }
// }

//   Future likePost(PostModel post, bool current) async {
//     print(post.id);
//     if (current) {
//       post.likesCount = post.likesCount - 1;
//       await FirebaseFirestore.instance
//           .collection("posts")
//           .doc(post.id)
//           .collection("likes")
//           .doc(FirebaseAuth.instance.currentUser?.uid)
//           .delete();
//     }
//     if (!current) {
//       post.likesCount = post.likesCount + 1;
//       await FirebaseFirestore.instance
//           .collection("posts")
//           .doc(post.id)
//           .collection("likes")
//           .doc(FirebaseAuth.instance.currentUser?.uid)
//           .set({});
//     }
//   }
//     Stream<bool> getCurrentUserLike(PostModel post) {
//     return FirebaseFirestore.instance
//         .collection("posts")
//         .doc(post.id)
//         .collection("likes")
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.exists;
//     });
//   }
//  Future<List<PostModel>> getReplies(PostModel post) async {
//     QuerySnapshot querySnapshot = await post.ref
//         .collection("replies")
//         .orderBy('timestamp', descending: true)
//         .get();

//     return _postListFromSnapshot(querySnapshot);
//    }

