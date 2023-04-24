import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRecommendationPage extends StatefulWidget {
  @override
  _GroupRecommendationPageState createState() => _GroupRecommendationPageState();
}

class _GroupRecommendationPageState extends State<GroupRecommendationPage> {
  String _recommendedGroups = '';

  @override
  void initState() {
    super.initState();
    recommendGroups();
  }

  Future<String> getAgeAndDegree() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

    final userData = await userRef.get();
    final age = userData.get('age');
    final degree = userData.get('degree');

    return '{"age": $age, "degree": "$degree"}';
  }

  Future<void> recommendGroups() async {
    final ageAndDegree = await getAgeAndDegree();
    final url = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/recommend_group',
    );
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: ageAndDegree);

    final responseData = json.decode(response.body);
    final recommendedGroups = responseData['recommended_groups'] as List<dynamic>;

    setState(() {
      _recommendedGroups = recommendedGroups.map((group) => group['groupName']).join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Groups'),
      ),
      body: Center(
        child: Text('Recommended Groups: $_recommendedGroups'),
      ),
    );
  }
}