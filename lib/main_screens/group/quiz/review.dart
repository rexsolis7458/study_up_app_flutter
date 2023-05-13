import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Review extends StatefulWidget {
  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  getQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection('QNA')
        .get();
  }

  uploadQuizTaken(String quizId, Map<String, dynamic> questionData) async {
    await FirebaseFirestore.instance
        .collection("Quiz Taken")
        .doc(quizId)
        .collection('Quizzes')
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Scaffold(),
      ),
    );
  }
}
