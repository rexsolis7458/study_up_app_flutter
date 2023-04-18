import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/files/viewPDF.dart';
import 'package:study_up_app/main_screens/profile/viewUserPDF.dart';

class UserFiles extends StatefulWidget {
  const UserFiles({Key? key}) : super(key: key);

  @override
  State<UserFiles> createState() => _UserFilesState();
}

class _UserFilesState extends State<UserFiles> {
  final storage = FirebaseStorage.instance;
  late Future<ListResult> userFiles = Future.value(ListResult([]));

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    // Get the current user's uid
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    // Get the current user's groups
    final groupsSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContains: userId)
        .get();

    // Create a list to store all the user's files
    final allFiles = <Reference>[];

    // Loop through all the groups the user is a member of
    for (var group in groupsSnapshot.docs) {
      final groupId = group.id;
      // Get the current user's files for this group
      if (userId != null) {
        // Pass the required arguments to the getUserFiles method
        final result = await getUserFiles(groupId, userId);
        allFiles.addAll(result.items);
      }
    }

    setState(() {
      userFiles = Future.value(ListResult(allFiles));
    });
  }

  Future<ListResult> getUserFiles(String groupId, String userId) async {
    List<Reference> items = [];
    final result = await FirebaseStorage.instance
        .ref()
        .child('Pdf files/$groupId/$userId')
        .list();
    items.addAll(result.items);
    return ListResult(items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Files'),
      ),
      body: FutureBuilder<ListResult>(
        future: userFiles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final files = snapshot.data!.items;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return Card(
                  color: BGColor,
                  child: ListTile(
                    title: Text(file.name),
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      size: 40,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return userPdf(file);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ListResult {
  final List<Reference> items;

  ListResult(this.items);
}
