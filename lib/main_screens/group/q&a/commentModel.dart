import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late String id;
  late final String creator;
  late final String question;
  late final String originalId;


 CommentModel(
      {required this.id,
      required this.creator,
      required this.question,
      required this.originalId,});

  get ref => null;

    CommentModel.fromDocumentSnapshot({DocumentSnapshot? doc})
  {
    id = doc!.get('id');
    creator = doc.data().toString().contains('creator') ? doc.get('creator') : '';
    question = doc.data().toString().contains('question') ? doc.get('question') : '';
    originalId = doc.data().toString().contains('groupCreated') ? doc.get('originalId') : '';
  }
}

