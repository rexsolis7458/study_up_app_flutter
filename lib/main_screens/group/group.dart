import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/q&a/feed.dart';
import 'files/files.dart';
import 'quiz/create_quiz.dart';
import 'schedule/sched.dart';

class Group extends StatefulWidget {
  @override
  State<Group> createState() => _GroupState();
}

String chatRoomId(String user1, String user2) {
  if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return "$user1$user2";
  } else {
    return "$user2$user1";
  }
}

class _GroupState extends State<Group> {

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Programming 1'),
          actions: [
            // action button
            IconButton(
              icon: Icon(Icons.message_rounded),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => GroupChat(
                //         chatRoomId: 'roomId',
                //       ),
                //     ));
              },
            ),
          ],
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
              child: HomeFile(),
            ),
            Center(
              child: Feed(),
            ),
            Center(
              child: CreateQuiz(),
            ),
            Center(
              child: Sched(),
            ),
          ],
        ),
      ));
}
