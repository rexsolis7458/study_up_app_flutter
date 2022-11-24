import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late final String creator;
  late final Timestamp timestamp;

  CommentModel({
    required this.creator,
    required this.timestamp,
  });

  get ref => null;

  // CommentModel.fromDocumentSnapshot({DocumentSnapshot? doc}) {
  //   id = doc!.get('id');
  //   creator =
  //       doc.data().toString().contains('creator') ? doc.get('creator') : '';

  // }
}
