import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:fluttertoast/fluttertoast.dart';

class UploadPDFs extends StatefulWidget
{
  final DocumentSnapshot group;

  UploadPDFs(this.group);

  @override
  _UploadPDFsState createState() => _UploadPDFsState();
}

class _UploadPDFsState extends State<UploadPDFs>
{
  String uploaded = "Waiting for the files to be uploaded";

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<firebase_storage.UploadTask?> uploadFile(File file) async {  
  if (file == null) { 
    print("No File was Picked!");
    Fluttertoast.showToast(
      msg: "No File was Picked!",
      textColor: Colors.white
    );
    
    return null;
  } 

  firebase_storage.UploadTask uploadTask;  
  
  // Create a Reference to the file  
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance  
  .ref('Pdf files')
  .child(widget.group.id)
      .child('${Path.basename(file.path)}');  
  
  final metadata = firebase_storage.SettableMetadata(  
      contentType: 'file/df',  
      customMetadata: {'picked-file-path': file.path});  
  print("Uploading..!");  
  
  uploadTask = ref.putData(await file.readAsBytes(), metadata);  
  
  print("done..!");  
  return Future.value(uploadTask);  
}


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text(
            'Select File'
          ),
          onPressed: () async {
            final path = await FlutterDocumentPicker.openDocument();
            print(path);
            File file = File(path!);
            firebase_storage.UploadTask? task = await uploadFile(file);
            Navigator.pop(context);
          },
        ),
      )
    );
  }
}