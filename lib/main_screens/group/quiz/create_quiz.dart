// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz_form.dart';
import 'package:study_up_app/services/database.dart';

class CreateQuiz extends StatefulWidget {
  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  Stream? quizStream;

  DatabaseService databaseService = new DatabaseService();

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
                      title: snapshot.data.docs[index].data['quizTitle'],
                      desc: snapshot.data.docs[index].data['quizDesc'],
                      quizId: snapshot.data.docs[index].data['quizId'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizesData().then((val) {
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
                context, MaterialPageRoute(builder: (context) => QuizForm()));
          }),
    );
  }
}

class QuizTile extends StatelessWidget {
  // final String imgUrl;
  final String title;
  final String desc;
  final String quizId;

  // QuizTile({required this.imgUrl, required this.title, required this.desc});
  QuizTile({required this.title, required this.desc, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Quiz(
        //       quizId,
        //     )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // child: Image.network(
              //   imgUrl,
              //   width: MediaQuery.of(context).size.width - 48,
              //   fit: BoxFit.cover,
              // ),
            ),
            Container(
              // color: ButtonColor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ButtonColor,
              ),
              color: Colors.black26,
              alignment: Alignment.center,
              child: Column( 
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      desc,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
