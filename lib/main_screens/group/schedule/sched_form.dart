import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_up_app/Widgets/tasks_widget.dart';
import 'package:study_up_app/main_screens/group/schedule/sched_sample.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../models/event_dataSource.dart';
import '../../../provider/event_provider.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        title: Text(
          'StudyUp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Cal(),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: EventDataSource(events),
          initialSelectedDate: DateTime.now(),
          cellBorderColor: Colors.transparent,
          onTap: (details) {
            final provider = Provider.of<EventProvider>(context, listen: false);
            provider.setDate(details.date!);
            showModalBottomSheet(
                context: context, builder: (context) => TasksWidget());
          },
        ),
      ),
    );
  }
}
