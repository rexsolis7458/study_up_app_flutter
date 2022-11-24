import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_up_app/models/group.dart';
import 'package:study_up_app/models/users.dart';

import '../main_screens/group/q&a/commentModel.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "id": user.id,
        "fname": user.fname.toString(),
        "lname": user.lname.toString(),
        "email": user.email,
        "profPic": user.profPic.toString(),
        // "password": user.password,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection("users").doc(id).get();

      return UserModel.fromDocumentSnapshot(doc: doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String?> createGroup(String groupName, String userUid) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(userUid);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        'groupName': groupName,
        'groupLeader': userUid,
        'members': members,
        'groupCreated': Timestamp.now(),
      });

      await _firestore.collection("users").doc(userUid).update({
        'groupId': _docRef.id,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(userUid);
      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
      });

      await _firestore.collection("users").doc(userUid).update({
        'groupId': groupId,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<GroupModel> getGroup(String groupId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('groups').doc(groupId).get();

      return GroupModel.fromDocumentSnapshot(doc: doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

//quiz
class DatabaseService {
  Future<void> addQuizData(String quizId, Map<String, dynamic> quizData) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(
      String quizId, Map<String, dynamic> questionData) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection('QNA')
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getQuizesData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection('QNA')
        .get();
  }
}

//question
class CommentService {
  Future<void> addCommentData(
      String commentId, Map<String, dynamic> commentData) async {
    await FirebaseFirestore.instance
        .collection("Comment")
        .doc(commentId)
        .set(commentData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getCommentsData() async {
    return await FirebaseFirestore.instance.collection("Comment").snapshots();
  }

  getCommentData(String commentId) async {
    return await FirebaseFirestore.instance
        .collection("Comment")
        .doc(commentId)
        .collection('QNA')
        .get();
  }
}

//questions and answers
// class PostService {
//   List<CommentModel> _postListFromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//       return CommentModel(
//         id: doc.id,
//         question: 'question',
//         creator: 'creator',
//         originalId: 'originalId',
//       );
//     }).toList();
//   }

//   CommentModel? _postFromSnapshot(DocumentSnapshot snapshot) {
//     return snapshot.exists
//         ? CommentModel(
//             id: snapshot.id,
//             question: 'question',
//             creator: 'creator',
//             originalId: 'originalId',
//           )
//         : null;
//   }

//   Future savePost(question) async {
//     await FirebaseFirestore.instance.collection("Question").add({
//       'question': question,
//       'creator': FirebaseAuth.instance.currentUser?.uid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   Future reply(CommentModel post, String question) async {
//     if (question == '') {
//       return;
//     }
//     await post.ref.collection("replies").add({
//       'question': question,
//       'creator': FirebaseAuth.instance.currentUser?.uid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<CommentModel?> getPostById(String id) async {
//     DocumentSnapshot postSnap =
//         await FirebaseFirestore.instance.collection("Question").doc(id).get();

//     return _postFromSnapshot(postSnap);
//   }

//   Stream<List<CommentModel>> getPostsByUser(uid) {
//     return FirebaseFirestore.instance
//         .collection("Question")
//         .where('creator', isEqualTo: uid)
//         .snapshots()
//         .map(_postListFromSnapshot);
//   }

//   Future<List<CommentModel>> getReplies(CommentModel question) async {
//     QuerySnapshot querySnapshot =
//         await question.ref.collection("replies").get();

//     return _postListFromSnapshot(querySnapshot);
//   }
// }
