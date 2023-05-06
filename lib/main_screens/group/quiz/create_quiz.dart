import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz_form.dart';
import 'package:study_up_app/services/database.dart';

class CreateQuiz extends StatefulWidget {
  final DocumentSnapshot group;

  CreateQuiz(this.group);
  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  Stream? quizStream;

  getQuizesData() async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .where('groupId', isEqualTo: widget.group.id)
        .snapshots();
  }

  Widget quizList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                      groupId: widget.group.id,
                      title: snapshot.data.docs[index].data()['quizTitle'],
                      desc: snapshot.data.docs[index].data()['quizDescription'],
                      quizId: snapshot.data.docs[index].data()['quizId'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    getQuizesData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quizList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizForm(widget.group)));
          }),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title;
  final String desc;
  final String quizId;
  final String groupId;

  DatabaseService databaseService = new DatabaseService();

  QuizTile(
      {required this.title,
      required this.desc,
      required this.quizId,
      required this.groupId});

  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Quiz(
                      quizId,
                    )));
      },
      child: SingleChildScrollView(
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
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                desc,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Color.fromARGB(255, 223, 58, 46),
                    onPressed: () async {
                      final delete = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Event?"),
                          content:
                              const Text("Are you sure you want to delete?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );
                      if (delete ?? false) {
                        databaseService.deleteQuizData(quizId);
                      }
                    },
                  ),
                  if (userId != null)
                    IconButton(
                      icon: Icon(
                        Icons.flag_outlined,
                      ),
                      onPressed: () {
                        databaseService.addQuizToFavorites(quizId, userId);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Quiz added to favorites!"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
