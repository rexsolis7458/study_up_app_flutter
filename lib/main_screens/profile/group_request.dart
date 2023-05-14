import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class GroupRequestsPage extends StatefulWidget {
  const GroupRequestsPage({Key? key}) : super(key: key);

  @override
  _GroupRequestsPageState createState() => _GroupRequestsPageState();
}

class _GroupRequestsPageState extends State<GroupRequestsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<Stream<QuerySnapshot>> _groupRequestsStreams;

  @override
  void initState() {
    super.initState();

    // Get the current user's ID
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final String uid = currentUser.uid;

      // Query for groups where the current user is the leader
      _groupRequestsStreams = [];
      _firestore
          .collection("groups")
          .where("groupLeader", isEqualTo: uid)
          .get()
          .then((groupQuerySnapshot) {
        for (final groupDoc in groupQuerySnapshot.docs) {
          final groupId = groupDoc.id;

          // Create a stream of group requests for each group
          final groupRequestsStream = _firestore
              .collection("group_requests")
              .where("groupId", isEqualTo: groupId)
              .snapshots();

          setState(() {
            _groupRequestsStreams.add(groupRequestsStream);
          });
        }
      });
    } else {
      // Handle the case where there is no authenticated user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group Requests")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _mergeGroupRequestStreams(_groupRequestsStreams),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data?.docs ?? [];

          if (requests.isEmpty) {
            return Center(child: Text("No requests found."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (BuildContext context, int index) {
              final request = requests[index];

              return Card(
                child: ListTile(
                  title: Text(request["usersName"]),
                  subtitle: Text(request["groupName"]),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      // Add the user to the group's members array
                      final groupDocRef = _firestore
                          .collection("groups")
                          .doc(request["groupId"]);

                      await groupDocRef.update({
                        'members': FieldValue.arrayUnion([request["userId"]]),
                      });

                      // Delete the request document
                      await request.reference.delete();
                    },
                    child: Text("Accept"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _mergeGroupRequestStreams(
      List<Stream<QuerySnapshot>> streams) {
    return MergeStream(streams);
  }
}
