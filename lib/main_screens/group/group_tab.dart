

import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/createGroup.dart';
import 'package:study_up_app/main_screens/group/group.dart';

class GroupTab extends StatefulWidget
{
  final String? currentUserId;

  GroupTab({Key? key, this.currentUserId}) : super(key: key);
  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Pressed');
          Navigator.pushAndRemoveUntil(context,
           MaterialPageRoute(builder: (context) => CreateGroup(),
           ), (route) => false
           );
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 300.0, horizontal: 0.0),
        child: Center(
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
            }
          ),
        ),
      ),
    );

}
}