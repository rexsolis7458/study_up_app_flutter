import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/createGroup.dart';
import 'package:study_up_app/main_screens/group/group.dart';

import '../../helper/const.dart';
import 'joinGroup.dart';

class GroupTab extends StatefulWidget {
  final String? currentUserId;

  GroupTab({Key? key, this.currentUserId}) : super(key: key);
  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  void _goToCreate(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateGroup(),
        ));
  }

  void _goToJoin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const JoinGroup(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'My Groups',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton.extended(
              onPressed: () => _goToCreate(context),
              label: const Text("Create Group"),
            ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton.extended(
                onPressed: () => _goToJoin(context),
                label: const Text("Join Group"),
              )), // but
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: InkWell(
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 20,
                      ),
                      Text('Programming 1'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('1234567'),
                      SizedBox(
                        width: 150,
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Group()),
            //   );
            // },
          ),
        ),
      ),
    );
  }
}
