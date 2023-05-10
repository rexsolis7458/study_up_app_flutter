import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helper/const.dart';
import 'event.dart';

class EditEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Event event;
  const EditEvent(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.event})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BGColor,
      appBar: AppBar(title: const Text("Edit Event")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(
            height: 5,
          ),
          InputDatePickerFormField(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
            onDateSubmitted: (date) {
              print(date);
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'title'),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.timer),
                      hintText: "Enter Time",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        print(pickedTime.format(context));
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        print(parsedTime);
                        String formattedTime =
                            DateFormat('hh:mm').format(parsedTime);
                        String amPm = parsedTime.hour < 12 ? "AM" : "PM";
                        formattedTime = "$formattedTime $amPm";

                        setState(() {
                          _timeController.text = formattedTime;
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'description'),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    final time = _timeController.text;
    if (title.isEmpty) {
      print('title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance
        .collection('Events')
        .doc(widget.event.id)
        .update({
      "title": title,
      "description": description,
      "time": time,
      "date": Timestamp.fromDate(_selectedDate),
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
