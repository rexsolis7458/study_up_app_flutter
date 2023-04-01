import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'events.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;


  @override
  String getSubject(int index) => getEvent(index).title;

    @override
  Color getColor(int index) => getEvent(index).backgroundColor;

}
