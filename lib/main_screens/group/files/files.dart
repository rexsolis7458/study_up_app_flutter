import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'pdf.dart';
import 'viewPDF.dart';

class HomeFile extends StatefulWidget {
  final DocumentSnapshot group;

  HomeFile(this.group, {Key? key}) : super(key: key);

  @override
  State<HomeFile> createState() => _HomeFileState();
}

class _HomeFileState extends State<HomeFile> {
  PDFDocument document = PDFDocument();

  late Future<ListResult> futureFiles;

  double? ratingValue;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    final id = widget.group.id;
    futureFiles = FirebaseStorage.instance.ref('/Pdf files/$id').listAll();
  }

  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  Future<double> getAverageRating(String id) async {
    CollectionReference fLists =
        FirebaseFirestore.instance.collection('File Info');
    QuerySnapshot querySnapshot =
        await fLists.doc(id).collection('Ratings').get();
    List<QueryDocumentSnapshot> ratings = querySnapshot.docs;
    double sum = 0;
    int count = 0;
    for (QueryDocumentSnapshot rating in ratings) {
      double value = double.parse(rating['rating']);
      sum += value;
      count++;
    }
    if (count == 0) {
      return 0.0;
    }
    return sum / count;
  }

  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<ListResult>(
          future: futureFiles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final files = snapshot.data!.items;

              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return Card(
                    color: BGColor,
                    child: ListTile(
                      title: Text(file.name),
                      leading: const Icon(
                        Icons.picture_as_pdf,
                        size: 40,
                      ),
                      subtitle: FutureBuilder<double>(
                        future: getAverageRating(file.name),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Calculating rating...');
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final rating = snapshot.data!;
                            return Text(
                                // rating > 0.0
                                // ?
                                'Average rating: ${rating.toStringAsFixed(2)}'
                                // :
                                // 'Rate it!',
                                );
                          }
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () async {
                          final delete = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Event?"),
                              content: const Text(
                                  "Are you sure you want to delete?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );
                          if (delete ?? false) {
                            _delete(file.fullPath);
                          }
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return loadPdf(file);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error occured'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadPdf(widget.group),
              ),
            );
          },
        ),
      );
}
