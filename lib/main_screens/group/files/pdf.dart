import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/files/file_model.dart';
import '../../../helper/const.dart';


class UploadPdf extends StatefulWidget {
  final DocumentSnapshot group;
  UploadPdf(this.group);

  @override
  _UploadPdfState createState() => _UploadPdfState();
}

class _UploadPdfState extends State<UploadPdf> {
  FileModel fileModel = FileModel(
      fileName: '',
      rateID: randomAlphaNumeric(16),
      ratingValue: 0,
      fileID: randomAlphaNumeric(16),
      value: '',
      average: 0,
      updateid: '');

  // FileLists fileLists = FileLists();

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

    firebase_storage.UploadTask uploadTask;
    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('Pdf files')
        .child(widget.group.id)
        .child(fileModel.fileName);

    final metadata = firebase_storage.SettableMetadata(
      contentType: 'pdf',
      customMetadata: {
        'picked-file-path': file.path,
        'token': fileModel.fileID
      },
    );
//for db
    CollectionReference fLists =
        FirebaseFirestore.instance.collection('File Lists');
    var result = await fLists.add(
      {
        "date": Timestamp.fromDate(DateTime.now()),
        'fileName': fileModel.fileName,
        'id': randomAlphaNumeric(16)
      },
    );
    
    uploadTask = ref.putData(await file.readAsBytes(), metadata);
    print("Uploaded");
    Fluttertoast.showToast(
      msg: "Uploaded",
      textColor: Colors.white,
    );
    return Future.value(uploadTask);
  }

  CollectionReference filesCollection =
      FirebaseFirestore.instance.collection("File Lists");
  @override
  Widget build(BuildContext context) {
    // Set initial value for fileNameController

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
                setState(() {
                  fileModel = FileModel(
                    fileName: val,
                    rateID: fileModel.rateID,
                    ratingValue: fileModel.ratingValue,
                    fileID: fileModel.fileID,
                    value: fileModel.value,
                    average: fileModel.average,
                    updateid: fileModel.updateid,
                  );
                });
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
