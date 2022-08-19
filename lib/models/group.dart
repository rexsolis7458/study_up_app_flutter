import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel
{
  late String? groupId;
  late String? groudName;
  late String? groupLeader;
  late List<String>? members;
  late Timestamp? groupCreated;


  GroupModel({
    required this.groupId,
    required this.groudName,
    required this.groupLeader,
    required this.members,
    required this.groupCreated,
  });

  GroupModel.fromDocumentSnapshot({DocumentSnapshot? doc})
  {
    groupId = doc!.get('groupId');
    groudName = doc.data().toString().contains('groupName') ? doc.get('groupName') : '';
    groupLeader = doc.data().toString().contains('groupLeader') ? doc.get('groupLeader') : '';
    groupCreated = doc.data().toString().contains('groupCreated') ? doc.get('groupCreated') : '';
  }
}