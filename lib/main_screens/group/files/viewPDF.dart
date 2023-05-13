import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/files/file_model.dart';
import 'package:study_up_app/main_screens/group/files/rate.dart';
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
                index: '',
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
  String index;
  // final String average;
  ViewPDF(this.document,
      {required this.fileName, required this.index
      //  required this.average
      });
  FileModel fileModel = FileModel(
      fileName: '',
      rateID: randomAlphaNumeric(16),
      ratingValue: 0,
      fileID: randomAlphaNumeric(16),
      uploader: '',
      value: '',
      average: 0,
      updateid: '');

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final currentUserId = user!.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            fileName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              icon: const BackButtonIcon(),
              onPressed: () async {
                QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection('File Lists')
                    .where('fileName', isEqualTo: fileName)
                    .get();

                if (snapshot.docs.isNotEmpty) {
                  String uploader = snapshot.docs[0].get('uploader');
                  if (uploader != currentUserId) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return RateFile(fileName);
                        },
                      ),
                    );
                  } else {
                  Navigator.pop(context);
                }
                } else {
                  Navigator.pop(context);
                }
              }),
        ),
        body: PDFViewer(document: document));
  }
}
