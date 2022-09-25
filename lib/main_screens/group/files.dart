import 'dart:io';
import 'dart:math';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Files extends StatefulWidget {
  const Files({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
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
        .ref()
        .child('files')
        .child('/some-file.pdf');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    uploadTask = ref.putData(await file.readAsBytes(), metadata);
    print("Uploaded");
    Fluttertoast.showToast(
      msg: "Uploaded",
      textColor: Colors.white,
    );
    return Future.value(uploadTask);
  }

//Viewing of files

  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('files')
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
  //       .ref('notes/name.pdf')
  //       .getDownloadURL();
  //   print(downloadURL);
  //   PDFDocument doc = await PDFDocument.fromURL(downloadURL);
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               ViewPDF(doc))); //Notice the Push Route once this is done.
  // }

  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   listExample();
  //   downloadURLExample();
  //   print("All done!");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.all(6),
                  child: FittedBox(
                    child: Icon(
                      Icons.file_copy_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
                title: Text('Document.pdf'
                    // ignore: deprecated_member_use
                    ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {},
                ),
              ),
            ),
            //},
            //itemCount: transactions.length,
            //),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final path = await FlutterDocumentPicker.openDocument();
          print(path);
          File file = File(path!);
          firebase_storage.UploadTask? task = await uploadFile(file);
          Navigator.pop(context);
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

// class ViewPDF extends StatelessWidget {
//   PDFDocument document;
//   ViewPDF(this.document);

//   @override
//   Widget build(BuildContext context) {
//     return PdfViewer(document: document);
//   }
// }