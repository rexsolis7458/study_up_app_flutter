// import 'dart:async';
// import 'dart:core';
// import 'dart:io';
// import 'dart:math';

// import 'package:file_picker/file_picker.dart';
// import 'package:get/get.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// class Upload extends GetxController {
//   var numberOfUploads = "Waiting for image to upload".obs;
//   String get numberUploads => numberOfUploads.value;

//   startUploading() async {
//     List<String> imgUrls = [];

//     FilePickerResult? results = await selectImages();

//     if (results != null) {
//       List<String?> allPathResults = results.paths;

//       List<File> ResultFiles =
//           allPathResults.map((StringPath) => File(StringPath!)).toList();
//       File fileEach;

//       for (fileEach in ResultFiles) {
//         String fileName = await generateFileName();

//        List<int> assets = fileEach.readAsBytesSync();

//         final metadata = firebase_storage.SettableMetadata(
//             contentType: 'pdf',
//             customMetadata: {'picked-file-path': fileEach.path});

//         firebase_storage.Reference storageReference = firebase_storage
//             .FirebaseStorage.instance
//             .ref('pdfs')
//             .child(fileName);
//         await storageReference.putData(assets, metadata).then((value) async {
//           var downloadUrl = await value.ref.getDownloadURL();
//           imgUrls.add(downloadUrl);
//         });
//         numberOfUploads.value = "Success ${imgUrls.length} uploaded";
//       }
//     } else {}
//   }

//   Future<FilePickerResult?> selectImages() async {
//     FilePickerResult? results = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       allowedExtensions: ['pdf'],
//       type: FileType.custom,
//     );
//     return results;
//   }

//   Future<String> generateFileName() async {
//     var randomNumber = new Random();
//     String randomName = " ";
//     String fileName = " ";

//     for (var i = 0; i < 10; i++) {
//       print(randomNumber.nextInt(100));
//       randomName += randomNumber.nextInt(100).toString();
//     }

//     fileName = '$randomName.pdf';
//     return fileName;
//   }
// }
