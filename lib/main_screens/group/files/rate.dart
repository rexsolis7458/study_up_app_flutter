import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/files/file_model.dart';
import 'package:study_up_app/main_screens/group/group.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../services/database.dart';

class RateFile extends StatefulWidget {
  @override
  _RateFileState createState() => _RateFileState();
}

class _RateFileState extends State<RateFile> {
  late String fileName;
  FileModel fileModel = FileModel(
      fileName: '',
      rateID: randomAlphaNumeric(16),
      ratingValue: 0,
      fileID: '',
      value: '',
      average: '',
      updateid: '');

  FileLists fileLists = FileLists();

  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //     .ref('Pdf files')
  //     .getData()
  //     .then((value) => null) as Reference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: AlertDialog(
            title: const Text("Rate this File"),
            content: Container(
              child: RatingBar(
                initialRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Colors.orange),
                    half: const Icon(
                      Icons.star_half,
                      color: Colors.orange,
                    ),
                    empty: const Icon(
                      Icons.star_outline,
                      color: Colors.orange,
                    )),
                onRatingUpdate: (value) {
                  setState(() {
                    fileModel.ratingValue = value;
                    print(fileModel.ratingValue);
                  });
                },
              ),
            ),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      fileModel.ratingValue != null
                          ? fileModel.ratingValue.toString()
                          : 'Rate it!',
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ],
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Group();
                            },
                          ),
                        );
                      },
                      child: const Text("Later"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              // fileModel.ratingValue.toString();
                              // FirebaseFirestore.instance
                              //     .collection('File Ratings')
                              //     .add({
                              //   'filename': fileModel.fileName,
                              //   'fileID': fileModel.rateID,
                              //   'rating': fileModel.ratingValue != null
                              //       ? fileModel.ratingValue.toString()
                              //       : 'Rating',

                              // });

                              // var fLists = FirebaseFirestore.instance
                              //     .collection('File Lists');
                              // fLists
                              //     .doc(fLists
                              //         .id) // <-- Doc ID where data should be updated.
                              //     .update({
                              //   'filename': fileModel.fileName,
                              //   'fileID': fileModel.rateID,
                              //   'rating': fileModel.ratingValue != null
                              //       ? fileModel.ratingValue.toString()
                              //       : 'Rating',
                              // });

                              FirebaseFirestore.instance
                                  .collection('Ratings')
                                  .doc(fileModel.updateid)
                                  .update({
                                'filename': fileModel.fileName,
                                'fileID': fileModel.rateID,
                                'rating': fileModel.ratingValue != null
                                    ? fileModel.ratingValue.toString()
                                    : 'Rating',
                              }).then((value) {
                                print("Success!");
                              });

                              return Group();
                              //Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: const Text("Rate"),
                    ),
                  ]),
            ]),
      ),
    ));
  }
}
