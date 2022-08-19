import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_up_app/models/group.dart';
import 'package:study_up_app/models/users.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "id": user.id,
        "fname": user.fname.toString(),
        "lname": user.lname.toString(),
        "email": user.email,
        // "password": user.password,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  
  Future<UserModel> getUser(String id) async 
  {
    try {
      DocumentSnapshot doc = 
          await _firestore.collection("users").doc(id).get();

      return UserModel.fromDocumentSnapshot(doc: doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String?> createGroup(String groupName, String userUid) async
  {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(userUid);
      DocumentReference _docRef = 
          await _firestore.collection("groups").add({
            'groupName' : groupName,
            'groupLeader' : userUid,
            'members' : members,
            'groupCreated' : Timestamp.now(),
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
        'groupId' : groupId,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }
  Future<GroupModel> getGroup(String groupId) async
  {
    try {
      DocumentSnapshot doc = 
           await _firestore.collection('groups').doc(groupId).get();

      return GroupModel.fromDocumentSnapshot(doc: doc);
    } catch (e)
    {
      print(e);
      rethrow;
    }
  }
}