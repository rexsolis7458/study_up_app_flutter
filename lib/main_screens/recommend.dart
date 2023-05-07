import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_up_app/models/users.dart';
import 'package:study_up_app/services/database.dart';

class RecommendScreen extends StatefulWidget {
  @override
  _RecommendScreenState createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  List<String> _predictions = [];
  String? _age;
  String? _gender;
  String? _degree;
  String? _institution;
  List<String> _subjectInterests = [];

  final User? user = FirebaseAuth.instance.currentUser;
  final UserModel _currentUser = UserModel();
  void joinGroup(BuildContext context, String groupName) async {
    String? returnString = await Database().joinGroupByName(groupName, user!.uid);
    if (returnString == "success") {
    }
  }
  
Future<void> _getRecommendations() async {
  String url = "http://192.168.0.104:5000/recommend";
  Map<String, dynamic> data = {
    "age": _age,
    "gender": _gender,
    "degree": _degree,
    "institution": _institution,
    "subject_interests": _subjectInterests
  };

  try {
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      List<String> predictions = List<String>.from(jsonDecode(response.body)["predictions"]);

      // get the collection of groups from Firebase
      QuerySnapshot groupSnapshot = await FirebaseFirestore.instance.collection("groups").get();

      // loop through each group document and check if its group ID matches a prediction
      for (QueryDocumentSnapshot groupDoc in groupSnapshot.docs) {
  String groupId = groupDoc.id;
  Map<String, dynamic>? data = groupDoc.data() as Map<String, dynamic>?;
  if (data != null) {
    String groupName = data["groupName"] as String;
    if (predictions.contains(groupId)) {
      setState(() {
        _predictions.add(groupName);
      });
    }
  }
}
    } else {
      throw Exception("Failed to get recommendations.");
    }
  } catch (e) {
    print(e);
  }
}

  Future<void> _getUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot userData = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get();

  setState(() {
    _age = userData["age"];
    _gender = userData["gender"];
    _degree = userData["degree"];
    _institution = userData["institution"];
    List<dynamic> subjectInterests = userData["subjectInterest"];
    _subjectInterests = List<String>.from(subjectInterests);
  });

    _getRecommendations();
  }

Widget _buildPredictionsList() {
  return Expanded(
    child: ListView.builder(
      itemCount: _predictions.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _predictions[index],
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => joinGroup(context, _predictions[index]),
                  child: Text('Join'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommendations"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Text("Top 5 predictions:", style: TextStyle(fontSize: 18.0)),
            _buildPredictionsList(),
          ],
        ),
      ),
    );
  }
}