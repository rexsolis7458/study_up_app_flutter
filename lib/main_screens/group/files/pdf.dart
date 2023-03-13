import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/files/pdf.dart';
import 'package:study_up_app/main_screens/group/files/viewPDF.dart';

import '../../../helper/const.dart';
import '../upload.dart';

class UploadPdf extends StatefulWidget {
  @override
  _UploadPdfState createState() => _UploadPdfState();
}

class _UploadPdfState extends State<UploadPdf> {
  late String fileName, fileId;

  //Upload upload = Get.put(Upload());
  String uploaded = "Waiting For Images To Be Uploaded";

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //Uploading of Files
  Future<firebase_storage.UploadTask?> uploadFile(File file) async {
    if (file == null) {
      print("No File was Picked!");
      Fluttertoast.showToast(
        msg: "No File was Picked!",
        textColor: Colors.white,
      );
      return null;
    }

    //fileId = randomAlphaNumeric(16);

    firebase_storage.UploadTask uploadTask;
    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('Pdf files')
        .child(fileName);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'pdf', customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes(), metadata);
    print("Uploaded");
    Fluttertoast.showToast(
      msg: "Uploaded",
      textColor: Colors.white,
    );
    return Future.value(uploadTask);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'StudyUp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
            child: TextFormField(
              validator: (val) => val!.isEmpty ? "File Name" : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.only(left: 30, bottom: 11, top: 11, right: 15),
                hintText: "File Name",
              ),
              onChanged: (val) {
                fileName = val;
              },
            ),
          ),
          SizedBox(
            height: 14,
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ButtonColor,
            ),
            onPressed: () async {
              final path = await FlutterDocumentPicker.openDocument();
              print(path);
              File file = File(path!);
              firebase_storage.UploadTask? task = await uploadFile(file);
              Navigator.pop(context);
            },
            child: Text('Upload File'),
          ),
        ],
      ),
    );
  }
}
