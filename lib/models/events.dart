import 'package:flutter/material.dart';

import '../helper/const.dart';

class Event {
  final String title;
  final String description;
  final String schedId;
  final Color backgroundColor;


  const Event({
    required this.title,
    required this.description,
    required this.schedId,
    this.backgroundColor = Colors.lightGreen,
  });
}
