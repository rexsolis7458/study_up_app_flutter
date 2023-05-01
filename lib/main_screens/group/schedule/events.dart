import 'package:flutter/material.dart';

import '../../../helper/const.dart';

class Event {
  final String title;
  final String description;
  final String schedId;

  const Event({
    required this.title,
    required this.description,
    required this.schedId,
  });
}
