import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';
import 'package:study_up_app/main_screens/group/schedule/event.dart';
import 'package:study_up_app/main_screens/group/schedule/event_item.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_event.dart';
import 'edit_event.dart';

class Cal extends StatefulWidget {
  final DocumentSnapshot group;
  const Cal({super.key, required this.group});

  @override
  _CalState createState() => _CalState();
}

class _CalState extends State<Cal> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Event>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('Events/${widget.group['groupName']}/events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Event> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BGColor,
      appBar: AppBar(
        title: Text(
          'StudyUp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(titleCentered: true),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            locale: 'en_US',
            rowHeight: 43,
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            weekendDays: const [DateTime.sunday, 6],
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadFirestoreEvents();
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              print(_events[selectedDay]);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              );

              // const CalendarStyle(
              //   weekendTextStyle: TextStyle(color: Colors.redAccent),
              //   selectedDecoration:
              //       BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              //   todayDecoration: BoxDecoration(
              //       color: Color.fromRGBO(76, 92, 50, 1),
              //       shape: BoxShape.circle),
              //   todayTextStyle: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 18.0,
              //       color: Colors.white),
              // );

              CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      day.toString(),
                    ),
                  );
                },
              );
            },
          ),
          ..._getEventsForTheDay(_selectedDay).map(
            (event) => EventItem(
              event: event,
              onTap: () async {
                final res = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditEvent(
                        firstDate: _firstDay, lastDate: _lastDay, event: event),
                  ),
                );
                if (res ?? false) {
                  _loadFirestoreEvents();
                }
              },
              onDelete: () async {
                final delete = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete Event?"),
                    content: const Text("Are you sure you want to delete?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
                if (delete ?? false) {
                  await FirebaseFirestore.instance
                      .collection('Events')
                      .doc(event.id)
                      .delete();
                  _loadFirestoreEvents();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddEvent(
                firstDate: _firstDay,
                lastDate: _lastDay,
                selectedDate: _selectedDay,
                group: widget.group,
              ),
            ),
          );
          if (result ?? false) {
            _loadFirestoreEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
