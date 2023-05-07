import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        setState(() {
          _predictions = List<String>.from(jsonDecode(response.body)["predictions"]);
        });
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _predictions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(_predictions[index]),
        );
      },
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