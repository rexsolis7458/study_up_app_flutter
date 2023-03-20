import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/createGroup.dart';
import 'package:study_up_app/main_screens/group/group.dart';

import '../../helper/const.dart';
import 'joinGroup.dart';

class GroupTab extends StatefulWidget {
  final String? currentUserId;

  const GroupTab({Key? key, this.currentUserId}) : super(key: key);
  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {

   final FirebaseAuth auth = FirebaseAuth.instance;
   
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
    final User? user = auth.currentUser;
    final uid = user!.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'My Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(2),
              child: FloatingActionButton.extended(
                heroTag: 'create',
                onPressed: () => _goToCreate(context),
                label: const Text("Create Group"),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              child: FloatingActionButton.extended(
                heroTag: 'join',
                onPressed: () => _goToJoin(context),
                label: const Text("Join Group"),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("groups").where('members', arrayContains: uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
            {
              if(snapshot.hasData)
              {
                final snap = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  primary: true,
                  itemCount: snap.length,
                  itemBuilder: (context, index)
                  {
                    final group = snap[index];
                    return Card(
                      elevation: 2,
                      child: GestureDetector
                      (
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Group(group)));
                          // Navigator.pushNamed(context, '/group', arguments: group);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: 10.0),
                              Text(
                                snap[index]['groupName'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                );
              }
              else {
                return const SizedBox();
              }
            }
          ),
        ));
  }
}
