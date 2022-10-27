import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/quiz/quiz_form.dart';
import 'files.dart';
import 'quiz/create_quiz.dart';

class Group extends StatefulWidget {
  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Programming 1'),
          centerTitle: true,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: 'Files',
              ),
              Tab(
                text: 'Q & A',
              ),
              Tab(
                text: 'Quizzes',
              ),
              Tab(
                text: 'Schedule',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Files(),
            ),
            Center(
              child: Text('Q & A'),
            ),
            Center(
              child: QuizForm(),
            ),
            Center(
              child: Text('SCHEDULE'),
            ),
          ],
        ),
      ));
}
