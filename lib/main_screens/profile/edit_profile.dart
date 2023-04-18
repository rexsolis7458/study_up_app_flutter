import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/models/users.dart';

class EditProfileForm extends StatefulWidget {
  final UserModel user;
  EditProfileForm({required this.user});

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late String _fname;
  late String _lname;
  late String _email;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // handle the case where there is no logged in user
        return;
      }

      final dataToUpdate = <String, dynamic>{};
      if (_fname.isNotEmpty) {
        dataToUpdate['fname'] = _fname;
      }
      if (_lname.isNotEmpty) {
        dataToUpdate['lname'] = _lname;
      }
      if (_email.isNotEmpty) {
        dataToUpdate['email'] = _email;
      }

      if (dataToUpdate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nothing to update')),
        );
        return;
      }

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update(dataToUpdate);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated')),
        );

        // Clear the form after submission
        _formKey.currentState!.reset();
        _fname = '';
        _lname = '';
        _email = '';
      } catch (error) {
        print('Error updating user: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: widget.user.firstname,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                    validator: (value) {
                    },
                    onSaved: (value) {
                      _fname = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: widget.user.lastname,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                    validator: (value) {
                    },
                    onSaved: (value) {
                      _lname = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: widget.user.email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) {
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
