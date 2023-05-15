import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String title;
  String content;
  String authorId;
  String posterName;
  Timestamp createdAt;
  List<String> upvoters;
  List<String> downvoters;
  String subject;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.posterName,
    required this.createdAt,
    required this.upvoters,
    required this.downvoters,
    required this.subject
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      posterName: data['posterName'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      upvoters: List<String>.from(data['upvoters'] ?? []),
      downvoters: List<String>.from(data['downvoters'] ?? []),
      subject: data['subject'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'content': content,
        'authorId': authorId,
        'posterName': posterName,
        'createdAt': createdAt,
        'upvoters': upvoters,
        'downvoters': downvoters,
        'subject': subject,
      };

  bool didUpvote(String userId) {
    return upvoters.contains(userId);
  }

  bool didDownvote(String userId) {
    return downvoters.contains(userId);
  }

  void upvote(String userId) {
    if (!upvoters.contains(userId)) {
      upvoters.add(userId);
    }

    if (downvoters.contains(userId)) {
      downvoters.remove(userId);
    }
  }

  void downvote(String userId) {
    if (!downvoters.contains(userId)) {
      downvoters.add(userId);
    }

    if (upvoters.contains(userId)) {
      upvoters.remove(userId);
    }
  }
}

class CommentModel {
  final String content;
  final String authorId;
  final String commenterName;
  final String postId;
  final Timestamp createdAt;

  CommentModel({
    required this.content,
    required this.authorId,
    required this.commenterName,
    required this.postId,
    required this.createdAt,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      content: data['content'],
      authorId: data['authorId'],
      commenterName: data['commenterName'],
      postId: data['postId'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'authorId': authorId,
      'commenterName': commenterName,
      'postId': postId,
      'createdAt': createdAt,
    };
  }
}
