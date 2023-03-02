import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:study_up_app/main_screens/group/files/pdf.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../services/database.dart';
import 'files.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoadURL extends StatefulWidget {
  @override
  _LoadURLState createState() => _LoadURLState();
}

class _LoadURLState extends State<LoadURL> {
  late String fileName;
  late Future<ListResult> futureFiles;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('Pdf files')
        .listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });
  }

  // Future<void> downloadURLExample() async {
  //   String downloadURL = await firebase_storage.FirebaseStorage.instance
  //       .ref('Pdf files $fileName')
  //       .getDownloadURL();
  //   print(downloadURL);
  //   PDFDocument doc = await PDFDocument.fromURL(downloadURL);
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               ViewPDF(doc))); //Notice the Push Route once this is done.
  // }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    listExample();
    // downloadURLExample();
    futureFiles = FirebaseStorage.instance.ref('Pdf files').listAll();
    print("All done!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Pdf files').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              return Row(
                children: <Widget>[
                  Expanded(child: Text(documentSnapshot['Pdf files']))
                ],
              );
            },
          );
        },
      ),
      // body: FutureBuilder<ListResult>(
      //     future: futureFiles,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         final files = snapshot.data!.items;

      //         return ListView.builder(
      //             itemCount: files.length,
      //             itemBuilder: (context, index) {
      //               final file = files[index];

      //               return ListTile(
      //                 title: Text(fileName),
      // trailing: IconButton(
      //   icon: const Icon(
      //     Icons.download,
      //     color: Colors.blue,
      //   ),
      //   onPressed: () => downloadURLExample(),
      // ),
      // );
      //         });
      //   } else if (snapshot.hasError) {
      //     return const Center(
      //       child: Text('Error occured'),
      //     );
      //   } else {
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   }
      // }),
      // body: FutureBuilder(
      //   future: _loadFiles(),
      //   builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return ListView.builder(
      //         itemCount: snapshot.data?.length ?? 0,
      //         itemBuilder: (context, index) {
      //           final Map<String, dynamic> pdf = snapshot.data![index];

      //           return Card(
      //             margin: const EdgeInsets.symmetric(vertical: 10),
      //             child: ListTile(
      //               dense: false,
      //               leading:Text(pdf['']),
      //               title: Text(pdf['uploaded_by']),
      //               subtitle: Text(pdf['description']),
      //               // trailing: IconButton(
      //               //   onPressed: () => _delete(image['path']),
      //               //   icon: const Icon(
      //               //     Icons.delete,
      //               //     color: Colors.red,
      //               //   ),
      //               // ),
      //             ),
      //           );
      //         },
      //       );
      //     }

      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
    );
  }
}



// class ViewPDF extends StatelessWidget {
//   PDFDocument document;
//   ViewPDF(this.document);
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: PDFViewer(document: document));
//   }
// }
