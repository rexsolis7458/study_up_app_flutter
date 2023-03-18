import 'package:flutter/material.dart';

import '../../../models/events.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
