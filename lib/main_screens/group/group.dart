import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/groupChat/groupChat.dart';
import 'package:study_up_app/main_screens/group/q&a/PostList.dart';
import 'files/files.dart';
import 'quiz/create_quiz.dart';
import 'schedule/sched.dart';

class Group extends StatefulWidget {

  Group(this.group,{Key? key}) : super(key: key);
  
  final DocumentSnapshot group;

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.group['groupName']),
          actions: [
            // action button
            IconButton(
              icon: Icon(Icons.message_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupChat(widget.group
                      ),
                    ));
              },
            ),
          ],
          centerTitle: true,
          bottom: const TabBar(
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
              child: HomeFile(widget.group),
            ),
            Center(
              child: PostList(widget.group),
            ),
            Center(
              child: CreateQuiz(widget.group),
            ),
            Center(
              child: Sched(widget.group),
            ),
          ],
        ),
      ));
}