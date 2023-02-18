import 'dart:io';
import 'dart:math';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:study_up_app/main_screens/group/files/pdf.dart';
import 'package:study_up_app/main_screens/group/files/viewPDF.dart';

import '../../../helper/const.dart';
import '../../../services/database.dart';
import '../upload.dart';

class Files extends StatefulWidget {
  const Files({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  late String fileName, fileId;
  Stream? filesStream;

  LoadURL loadURL = LoadURL();
  // FilesService filesService = new FilesService();

  Widget filesList() {
    return Container(
      child: StreamBuilder(
        stream: filesStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return FilesTile(
                      fileName: snapshot.data.docs[index].data()['fileName'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    LoadURL(val){
      setState(() {
        filesStream = val;
      });
    }

    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: filesList(),
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

class FilesTile extends StatelessWidget {
  late String fileName;

  FilesTile({required this.fileName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    // Text(
                    //   'No files added yet!',
                    //   style: TextStyle(
                    //     fontSize: 20.0,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 100,
                    // ),
                    // Container(
                    //     height: 200,
                    //     child: Image.asset(
                    //       'assets/waiting.png',
                    //       fit: BoxFit.cover,
                    //     )),
                    // ListView.builder(
                    //   itemBuilder: (ctx, index) {
                    Container(
                      // color: ButtonColor,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(),
                      ),

                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              leading: Padding(
                                padding: EdgeInsets.all(6),
                                child: FittedBox(
                                  child: Icon(
                                    Icons.file_copy_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              title: Text(fileName
                                  // ignore: deprecated_member_use
                                  ),
                              onTap: () => LoadURL(),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () {},
                              ),
                            ),
                          ]),
                      //},
                      //itemCount: transactions.length,
                      //),
                    )
                  ])),
            ],
          ),
        ],
      ),
    );
  }
}
