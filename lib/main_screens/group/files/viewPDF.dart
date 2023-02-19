import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:study_up_app/main_screens/group/files/pdf.dart';

import '../../../services/database.dart';
import 'files.dart';

class LoadURL extends StatefulWidget {
  @override
  _LoadURLState createState() => _LoadURLState();
}

class _LoadURLState extends State<LoadURL> {
  late String fileName;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('Files')
        .listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });
  }

  Future<void> downloadURLExample() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('files/$fileName')
        .getDownloadURL();
    print(downloadURL);
    PDFDocument doc = await PDFDocument.fromURL(downloadURL);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewPDF(doc))); //Notice the Push Route once this is done.
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    listExample();
    downloadURLExample();
    print("All done!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // filesList(),
          FutureBuilder<ListResult>(
              future: downloadURLExample,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final files = snapshot.data!.items;

                  return ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];

                        return ListTile(
                          title: Text(file.name),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.download,
                              color: Colors.blue,
                            ),
                            onPressed: () => LoadURL(),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error occured'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Pdf(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ViewPDF extends StatelessWidget {
  PDFDocument document;
  ViewPDF(this.document);
  @override
  Widget build(BuildContext context) {
    return Center(child: PDFViewer(document: document));
  }
}
