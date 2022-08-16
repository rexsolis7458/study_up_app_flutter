import 'package:flutter/material.dart';

class Group extends StatefulWidget
{
  @override
  
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group>
{
  @override
  Widget build(BuildContext context) => DefaultTabController(
  length: 4,
  child: Scaffold(
    appBar: AppBar(
      shape: Border(
        bottom: BorderSide(
          color: Colors.black
        ),
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
        Center(
          child: Text('FILES'),
        ),
        Center(
          child: Text('Q & A'),
        ),
        Center(
          child: Text('QUIZZES'),
        ),
        Center(
          child: Text('SCHEDULE'),
          ),
      ],
    ),
  ));
}