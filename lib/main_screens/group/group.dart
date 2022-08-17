import 'package:flutter/material.dart';
import 'files.dart';

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
          shape: Border(
            bottom: BorderSide(color: Colors.black),
          ),
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
            const Center(
              child: Files(),
            ),
            Center(
                //child: QandA(),
                ),
            Center(
                //child: Quizzes(),
                ),
            Center(
                //child: Schedules(),
                ),
          ],
        ),
      ));
}
