import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:study_up_app/main_screens/group/files/files.dart';
import 'package:study_up_app/main_screens/group/files/rate.dart';
import 'package:study_up_app/main_screens/group/group.dart';
import 'package:study_up_app/main_screens/group/group_tab.dart';

import '../../../helper/const.dart';

class loadPdf extends StatefulWidget {
  loadPdf(this.files, {Key? key}) : super(key: key);

  Reference files;

  @override
  State<loadPdf> createState() => _loadPdfState();
}

class _loadPdfState extends State<loadPdf> {
  Future<ListResult>? futureFiles;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> downloadURLExample() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(widget.files.fullPath)
        .getDownloadURL();

    print(downloadURL);
    PDFDocument doc = await PDFDocument.fromURL(downloadURL);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewPDF(
                doc,
                fileName: widget.files.name,
                // average: widget.files.average,
              )),
    );
  }

  @override
  void initState() {
    super.initState();
    downloadURLExample();
    print("All done!");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ViewPDF extends StatelessWidget {
  PDFDocument document;
  final String fileName;
  // final String average;
  ViewPDF(this.document, {required this.fileName,
  //  required this.average
   });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'PDF',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const BackButtonIcon(),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return RateFile(fileName);
                  },
                ),
              );
            },
          ),
        ),
        body: PDFViewer(document: document));
  }
}
