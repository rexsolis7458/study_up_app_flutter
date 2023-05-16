import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_up_app/main_screens/group/schedule/calendar.dart';

import '../../../helper/const.dart';

class AddEvent extends StatefulWidget {
  final DocumentSnapshot group;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  const AddEvent({
    Key? key,
    required this.firstDate,
    required this.lastDate,
    this.selectedDate,
    required this.group,
  }) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late DateTime _selectedDate;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BGColor,
      appBar: AppBar(title: const Text("Add Event")),
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
              labelText: 'title',
            ),
          ),
          const SizedBox(width: 20),
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
                        DateTime now = DateTime.now();
                        DateTime pickedDateTime = DateTime(now.year, now.month,
                            now.day, pickedTime.hour, pickedTime.minute);

                        String formattedTime =
                            DateFormat('hh:mm a').format(pickedDateTime);
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
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: 'description',
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
              Navigator.pop(context);
            },
            child: const Text("Add Event"),
          ),
        ],
      ),
    );
  }

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    final time = _timeController.text;
    if (title.isEmpty && description.isEmpty && time.isEmpty) {
      print('title cannot be empty');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Missing Information"),
            content: const Text("Please fill out all required fields."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cal(group: widget.group),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
      return;
    }
    await FirebaseFirestore.instance
        .collection('Events/${widget.group['groupName']}/events')
        .add({
      "id": widget.group.id,
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
