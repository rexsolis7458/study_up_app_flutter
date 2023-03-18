import 'package:flutter/material.dart';

import '../helper/const.dart';

class Event {
  final String title;
  final String description;
  final String schedId;
  // final DateTime from;
  // final DateTime to;
  final Color backgroundColor;


  const Event({
    required this.title,
    required this.description,
    required this.schedId,
    // required this.from,
    // required this.to,
    this.backgroundColor = Colors.lightGreen,
  });
}
