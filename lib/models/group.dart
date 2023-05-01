import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel
{
  late String? groupId;
  late String? groupName;
  late String? groupLeader;
  late List<String>? members;
  late Timestamp? groupCreated;


  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupLeader,
    required this.members,
    required this.groupCreated,
  });

  factory GroupModel.fromDocumentSnapshot(DocumentSnapshot doc)
  {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return GroupModel(
      groupId: doc.get('groupId'),
      groupName: data['groupName'] ?? '',
      groupLeader: data['groupLeader'] ?? '',
      groupCreated: data['groupCreated'] ?? '', 
      members: [],
    );
  }
}