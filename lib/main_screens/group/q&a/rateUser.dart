import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/files/file_model.dart';
import 'package:study_up_app/main_screens/profile/profileModel.dart';
import 'package:study_up_app/main_screens/profile/profile_tab.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/userController.dart';
import '../../../services/database.dart';
import '../../home/home_screen.dart';

class RateUser extends StatefulWidget {
  @override
  _RateUserState createState() => _RateUserState();
}

class _RateUserState extends State<RateUser> {
  ProfileModel profileModel = ProfileModel(
    rateID: randomAlphaNumeric(16),
    ratingValue: 0,
    value: '',
    average: 0,
  );

  @override
  Widget build(BuildContext context) => GetX<UserController>(
        initState: (_) async {
          Get.find<UserController>().user =
              await Database().getUser(Get.find<AuthController>().reference.id);
        },
        builder: (_) {
          String? userEmail = _.user.email;
          return Scaffold(
            body: Container(
              child: Center(
                child: AlertDialog(
                  title: const Text("Rate this User"),
                  content: Container(
                    child: RatingBar(
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
                        half: const Icon(Icons.star_half, color: Colors.orange),
                        empty: const Icon(Icons.star_outline,
                            color: Colors.orange),
                      ),
                      onRatingUpdate: (value) {
                        setState(() {
                          profileModel.ratingValue = value;
                          print(profileModel.ratingValue);
                        });
                      },
                    ),
                  ),
                  actions: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            profileModel.ratingValue != null
                                ? profileModel.ratingValue.toString()
                                : 'Rate it!',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 25),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          },
                          child: const Text(
                            "Cancel",
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            CollectionReference pLists = FirebaseFirestore
                                .instance
                                .collection('User Rating');

                            if (userEmail != null) {
                              pLists.doc(userEmail).collection('Ratings').add(
                                {
                                  'id': pLists.id,
                                  "created": Timestamp.fromDate(DateTime.now()),
                                  'rating': profileModel.ratingValue != null
                                      ? profileModel.ratingValue.toString()
                                      : 'Rating',
                                },
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            } else {
                              print('File name is empty');
                            }
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
        },
      );
}
