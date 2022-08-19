import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/group.dart';

import 'create_group.dart';
import 'join_group.dart';

class GroupTab extends StatefulWidget {
  final String? currentUserId;

  GroupTab({Key? key, this.currentUserId}) : super(key: key);
  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: Colors.black),
        ),
        title: Text('My Groups'),
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.white,
          tabs: [
            Tab(
              text: 'Create a Group',
            ),
            Tab(
              text: 'Join a Group',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          const Center(
            child: CreateGroup(),
          ),
          Center(
            JoinGroup(),
          ),
        ],
      ),
      child: InkWell(
          child: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 150,
                    ),
                    Text('Programming 1'),
                    SizedBox(
                      height: 10,
                    ),
                    Text('1234567'),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Group()),
            );
          }),
    );
  }
}
