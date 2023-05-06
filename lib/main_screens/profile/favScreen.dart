import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/quiz/create_quiz.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz.dart';
import 'package:study_up_app/services/database.dart';

class FavoriteQuizzes extends StatefulWidget {
  FavoriteQuizzes();
  @override
  State<FavoriteQuizzes> createState() => _FavoriteQuizzesState();
}

class _FavoriteQuizzesState extends State<FavoriteQuizzes> {
  Future<List<Map<String, dynamic>>>? favoriteQuizzes;

  Future<List<Map<String, dynamic>>> getFavoriteQuizzes(String userId) async {
  DocumentSnapshot favoritesSnapshot = await FirebaseFirestore.instance
    .collection('Favorites')
    .doc(userId)
    .get();

  Map<String, dynamic> data = favoritesSnapshot.data() as Map<String, dynamic>;
List<dynamic> quizIds = data['quizId'];

  List<Map<String, dynamic>> quizzes = [];

  for (String quizId in quizIds) {
    DocumentSnapshot quizSnapshot = await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(quizId)
        .get();
    if (quizSnapshot.exists) {
      Map<String, dynamic> quizData = quizSnapshot.data() as Map<String, dynamic>;
      quizData['quizId'] = quizId;
      quizzes.add(quizData);
    }
  }

  return quizzes;
}

  Widget quizList() {
    return Container(
      child: FutureBuilder(
        future: favoriteQuizzes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<Map<String, dynamic>> quizzes =
              snapshot.data as List<Map<String, dynamic>>;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quizData = quizzes[index];
              return QuizTile(
                title: quizData['quizTitle'],
                desc: quizData['quizDescription'],
                quizId: quizData['quizId'],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;
    favoriteQuizzes = getFavoriteQuizzes(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title;
  final String desc;
  final String quizId;

  QuizTile({
    required this.title,
    required this.desc,
    required this.quizId,
  });

  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Quiz(quizId),
          ),
        );
      },
      child: Container(
        child: Card(
          color: BGColor,
          child: ListTile(
            leading: const Icon(
              Icons.ballot_outlined,
              size: 40,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: MainColor,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              desc,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // You can add the favorite icon here if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}