import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/profile/edit.dart';
import 'package:study_up_app/models/users.dart';

class EditProfilePage extends StatelessWidget {
  final UserModel user;

  EditProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EditProfileForm(user: user),
        ),
      ),
    );
  }
}