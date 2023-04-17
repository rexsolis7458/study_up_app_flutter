import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/files/file_model.dart';

class RateFile extends StatefulWidget {
  final String fileName;

  RateFile(this.fileName);

  @override
  _RateFileState createState() => _RateFileState();
}

class _RateFileState extends State<RateFile> {
  FileModel fileModel = FileModel(
    fileName: '',
    rateID: randomAlphaNumeric(16),
    ratingValue: 0,
    fileID: '',
    value: '',
    average: 0,
    updateid: '',
  );

  @override
  void initState() {
    super.initState();
    fileModel.fileName = widget.fileName; // Set fileName from widget property
  }

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
                  half: const Icon(Icons.star_half, color: Colors.orange),
                  empty: const Icon(Icons.star_outline, color: Colors.orange),
                ),
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
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text("Later",),
                  ),
                  TextButton(
                    onPressed: () async {
                      CollectionReference fLists =
                          FirebaseFirestore.instance.collection('File Info');

                      if (fileModel.fileName.isNotEmpty) {
                        fLists
                            .doc(fileModel.fileName)
                            .collection('Ratings')
                            .add({
                          'filename': fileModel.fileName,
                          'id': fLists.id,
                          "created": Timestamp.fromDate(DateTime.now()),
                          'rating': fileModel.ratingValue != null
                              ? fileModel.ratingValue.toString()
                              : 'Rating',
                        });
                      } else {
                        print('File name is empty');
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Rate"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
