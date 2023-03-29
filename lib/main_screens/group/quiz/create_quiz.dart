import 'package:cloud_firestore/cloud_firestore.dart';
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

  // DatabaseService databaseService = new DatabaseService();

  getQuizesData() async {
    return await FirebaseFirestore.instance.collection("Quiz").where('groupId', isEqualTo: widget.group.id).snapshots();
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
                      // imgUrl: snapshot.data.doc[index].data['quizImgurl'],
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
                context, MaterialPageRoute(builder: (context) => QuizForm(widget.group)));
          }),
    );
  }
}

class QuizTile extends StatelessWidget {
  // final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  final String groupId;
  DatabaseService databaseService = new DatabaseService();

  // QuizTile({required this.imgUrl, required this.title, required this.desc});
  QuizTile({required this.title, required this.desc, required this.quizId, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Quiz(
                      quizId,
                    )));
      },
      child: Container(
          child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.ballot_outlined,
            size: 40,
          ),
          title: Text(
            title,
            style: TextStyle(
                color: MainColor, fontSize: 17, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            desc,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async {
                final delete = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete Event?"),
                    content: const Text("Are you sure you want to delete?"),
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
                  // _delete(file.fullPath);
                  databaseService.deleteQuizData(quizId);
                }
              }),
        ),
      )),
    );
  }
}
