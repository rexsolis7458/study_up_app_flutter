import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeFile extends StatefulWidget
{

  HomeFile({Key? key}) : super(key: key);
  
  @override

  State<HomeFile> createState() => _HomeFileState();
}

class _HomeFileState extends State<HomeFile>
{

  late Future<ListResult> futureFiles;
  
  @override
  void initState()
  {
    super.initState();

    futureFiles = FirebaseStorage.instance.ref('/pdf/files').listAll();
  }
  
  @override
  Widget build(BuildContext context) =>Scaffold(
    appBar: AppBar(
      title: const Text('Download Files'),
    ),
    body: FutureBuilder<ListResult>(
      future: futureFiles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final files = snapshot.data!.items;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index)
            {
              final file = files[index];

              return ListTile(
                title: Text(file.name),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: Colors.blue,
                  ),
                  onPressed: () => downloadFile(file),
                ),
              );
            }
          );
          
        } else if (snapshot.hasError)
        {
          return const Center(child: Text('Error occured'),);
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      }
    ),
  );

  Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded ${ref.name}'))
    );
  }
}
