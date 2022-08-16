// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Files extends StatefulWidget {
  const Files({super.key});

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  File? file;
  ImagePicker image = ImagePicker();
  String url = "";
  var name;
  // final List<Transaction> transactions;
  // final Function deleteTx;

  // TransactionList(this.transactions, this.deleteTx);

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );
    if (result != null) {
      File c = File(result.files.single.path.toString());
      setState(() {
        file = c;
        name = result.names.toString();
      });
      uploadFile();
    }
  }

  uploadFile() async {
    try {
      // url = await snapshot.ref.getDownloadURL();

      // print(url);
      if (url != null && file != null) {
        Fluttertoast.showToast(
          msg: "Done Uploaded",
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          textColor: Colors.white,
        );
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child:
          // transactions.isEmpty
          //     ?
          Column(
        children: <Widget>[
          Text(
            'No files added yet!',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
              height: 200,
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
              )),
          // ListView.builder(
          //   itemBuilder: (ctx, index) {
          //     return Card(
          //         elevation: 5,
          //         margin: EdgeInsets.symmetric(
          //           vertical: 8,
          //           horizontal: 5,
          //         ),
          //         child: ListTile(
          //           title: Text('chuchu'
          //               //transactions[index].title,
          //               // ignore: deprecated_member_use
          //               ),
          //           subtitle: Text('ksh'),
          //         ));
          //   },
          // ),

          FloatingActionButton(
            onPressed: () async {
              getFile();
              // final path = await FlutterDocumentPicker.openDocument();
              // print(path);
              // File file = File(path!);
              // firebase_storage.UploadTask? task = await uploadFile(file);
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          // floatingActionButtonLocation:
          // FloatingActionButtonLocation.endFloat;
        ],
      ),
    );
  }
}
