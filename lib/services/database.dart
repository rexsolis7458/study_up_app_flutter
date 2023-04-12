import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/controller/userController.dart';
import 'package:study_up_app/models/group.dart';
import 'package:study_up_app/models/users.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../main_screens/group/files/file_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "id": user.id,
        "firstname": user.firstname.toString(),
        "lastname": user.lastname.toString(),
        "email": user.email,
        "profilePicture": user.profilePicture.toString(),
         "birthday": user.birthday.toString(),
         "gender": user.gender.toString(),
         "institution": user.institution.toString(),
         "degree": user.degree.toString(),
          "age": user.age.toString(),
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

// Future<void> updateUserProfile(UserModel userModel, User user) async {
//     try {
//       await _firestore.collecton('users').doc(user.uid).update({
//         'firstName': userModel?.firstname,
//         'lastName': userModel.firstname,
//         'email': userModel.email,
//         'password': userModel.password,
//       });
//       await user.updateEmail(userModel.email);
//       await user.updateProfile(displayName: userModel.firstname);
//       print('User profile updated successfully!');
//     } catch (error) {
//       print('Error updating user profile: $error');
//     }
//   }

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

  // deleteQuizData(String quizId) async {
  //   return await FirebaseFirestore.instance
  //       .collection("Quiz")
  //       .get()
  //       .then((snapshot) {
  //     for (DocumentSnapshot ds in snapshot.docs) {
  //       ds.reference.delete();
  //     }
  //   });
  // }
  deleteQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .delete()
        .then((_) {
      print("success!");
    });
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

//replies
class ReplyService {
  Future<void> addReplyData(
      String replyId, Map<String, dynamic> replyData) async {
    String retVal = "error";

    await FirebaseFirestore.instance
        .collection("Reply")
        .doc(replyId)
        .set(replyData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getRepliesData() async {
    return await FirebaseFirestore.instance.collection("Reply").snapshots();
  }

  getReplyData(String replyId) async {
    return await FirebaseFirestore.instance
        .collection("Reply")
        .doc(replyId)
        .collection('QNA')
        .get();
  }

  replyList() {}
}

//sched
class ScheduleService {
  Future<void> addScheduleData(
      String schedId, Map<String, dynamic> schedData) async {
    await FirebaseFirestore.instance
        .collection("Event")
        .doc(schedId)
        .set(schedData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getScheduleData() async {
    return await FirebaseFirestore.instance.collection("Event").snapshots();
  }

  getSchedData(String schedId) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .doc(schedId)
        // .collection('QNA')
        .get();
  }
}
