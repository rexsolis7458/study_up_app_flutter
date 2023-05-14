import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/editable_text.dart';
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
        "subjectInterest": user.subjectInterest,
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

  Future<String?> createGroup(String groupName, String userUid,
      List<String> selectedValues, String from, String to) async {
    String retVal = "error";
    List<String> members = [];
    DocumentReference _docRef;

    try {
      members.add(userUid);
      _docRef = await _firestore.collection("groups").add({
        'groupName': groupName,
        'groupLeader': userUid,
        'members': members,
        'Subjects': selectedValues,
        'Time available Start': from,
        'Time available End': to,
        'groupCreated': Timestamp.now(),
        'groupId': '',
        'requiresApproval': true,
      });

      // Update the 'groupId' field with the ID of the newly created document
      await _docRef.update({'groupId': _docRef.id});

      // // Update the user document with the ID of the newly created group

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

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> joinGroupByName(
      String groupName, String userUid, String fullname) async {
    String retVal = "error";
    List<String> members = [];

    try {
      // Get the group document reference with the matching group name
      final groupDocRef = await _firestore
          .collection("groups")
          .where("groupName", isEqualTo: groupName)
          .limit(1)
          .get();

      if (groupDocRef.docs.isNotEmpty) {
        // Check if the group requires approval for new members
        bool requiresApproval =
            groupDocRef.docs.first.data()["requiresApproval"] ?? false;

        // If approval is required, add the user to the group requests collection
        if (requiresApproval) {
          final groupRequestsCollectionRef =
              _firestore.collection("group_requests");

          // Check if the user has already requested to join the group
          final querySnapshot = await groupRequestsCollectionRef
              .where("groupId", isEqualTo: groupDocRef.docs.first.id)
              .where("userId", isEqualTo: userUid)
              .get();

          if (querySnapshot.docs.isEmpty) {
            // Add a new request document to the group requests collection
            await groupRequestsCollectionRef.add({
              'groupId': groupDocRef.docs.first.id,
              'userId': userUid,
              'groupLeader': groupDocRef.docs.first.data()['groupLeader'],
              'timestamp': FieldValue.serverTimestamp(),
              'groupName': groupDocRef.docs.first.data()['groupName'],
              'usersName': fullname,
            });

            retVal = "pending";
          } else {
            retVal = "already_pending";
          }
        }
        // Otherwise, add the user to the group members list
        else {
          members.add(userUid);
          await groupDocRef.docs.first.reference.update({
            'members': FieldValue.arrayUnion(members),
          });

          retVal = "success";
        }
      } else {
        print("Group with name $groupName not found.");
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<GroupModel> getGroup(String groupId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('groups').doc(groupId).get();

      return GroupModel.fromDocumentSnapshot(doc);
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

  deleteQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .delete()
        .then((_) {
      print("success!");
    });
  }

  addQuizToFavorites(String quizId, String userId) async {
    final favoriteCollectionRef =
        FirebaseFirestore.instance.collection("Favorites").doc(userId);

    final favoriteDoc = await favoriteCollectionRef.get();
    if (!favoriteDoc.exists) {
      await favoriteCollectionRef
          .set({
            "userId": userId,
            "quizId": [quizId]
          })
          .then((value) => print(
              "Favorites document created and quiz added to favorites successfully!"))
          .catchError(
              (error) => print("Failed to add quiz to favorites: $error"));
      return;
    }

    final existingQuizIds = favoriteDoc.data()?["quizId"] ?? [];
    if (existingQuizIds.contains(quizId)) {
      print("Quiz is already in favorites");
      return;
    }

    final updatedQuizIds = List<String>.from(existingQuizIds)..add(quizId);

    await favoriteCollectionRef
        .update({"quizId": updatedQuizIds})
        .then((value) => print("Quiz added to favorites successfully!"))
        .catchError(
            (error) => print("Failed to add quiz to favorites: $error"));
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
