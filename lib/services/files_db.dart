// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../main_screens/group/files/file_model.dart';

// Future likePost(FileModel post, bool current) async {

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