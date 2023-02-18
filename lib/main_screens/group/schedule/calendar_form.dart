// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:random_string/random_string.dart';
// import 'package:study_up_app/provider/event_provider.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import '../../../models/events.dart';
// import '../../../services/database.dart';
// import '../../../utils/event_utils.dart';

// class CalendarForm extends StatefulWidget {
//   final Event? event;

//   const CalendarForm({
//     Key? key,
//     this.event,
//   }) : super(key: key);

//   @override
//   _CalendarFormState createState() => _CalendarFormState();
// }

// class _CalendarFormState extends State<CalendarForm> {
//   final _formKey = GlobalKey<FormState>();
//   final titleController = TextEditingController();
//   late DateTime fromDate;
//   late DateTime toDate;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //     _controller = CalendarController();
//   // }

//   late String schedId, schedTitle, schedDesc;

//   bool _isLoading = false;

//   ScheduleService scheduleService = new ScheduleService();

//   Future saveForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       schedId = randomAlphaNumeric(16);

//       Map<String, String> schedMap = {
//         'title': titleController.text,
//         'schedId': schedId,
//         'description': schedDesc,
//       };

//       // final event = Event(
//       //   title: titleController.text,
//       //   schedId: schedId,
//       //   description: 'Description',

//       // );

//       await scheduleService.addScheduleData(schedId, schedMap).then(
//         (value) {
//           if (!mounted) return;
//           setState(() {
//             _isLoading = false;
//           });
//         },
//       );

//       final isEditing = widget.event != null;
//       final provider = Provider.of<EventProvider>(context, listen: false);

//       if (isEditing) {
//         provider.editEvent(schedMap as Event, widget.event!);

//         Navigator.of(context).pop();
//       } else {
//         provider.addEvent(schedMap as Event);
//       }

//       Navigator.of(context).pop();
//     }
//     ;
//   }

//   // uploadSchedData() async {
//   //   if (_formKey.currentState!.validate()) {
//   //     setState(() {
//   //       _isLoading = true;
//   //     });

//   //     schedId = randomAlphaNumeric(16);

//   //     Map<String, String> schedMap = {
//   //       'schedId': schedId,
//   //       'schedTitle': schedTitle,
//   //       'schedDesc': schedDesc
//   //     };

//   //     await scheduleService.addScheduleData(schedId, schedMap).then(
//   //       (value) {
//   //         if (!mounted) return;
//   //         setState(() {
//   //           _isLoading = false;
//   //         });
//   //       },
//   //     );
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();

//     if (widget.event == null) {
//       fromDate = DateTime.now();
//       toDate = DateTime.now().add(Duration(hours: 2));
//     } else {
//       final event = widget.event!;

//       titleController.text = event.title;
//       // fromDate = event.from;
//       // toDate = event.to;
//     }
//   }

//   @override
//   void dispose() {
//     titleController.dispose();

//     super.dispose();
//   }

//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           leading: CloseButton(),
//           actions: buildEditingActions(),
//           centerTitle: true,
//           elevation: 0,
//           iconTheme: IconThemeData(
//             color: Colors.black54,
//           ),
//           title: Text(
//             'StudyUp',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.all(12),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 buildTitle(),
//                 SizedBox(height: 12),
//                 // buildDateTimePickers(),
//               ],
//             ),
//           ),
//         ),
//       );
//   List<Widget> buildEditingActions() => [
//         ElevatedButton.icon(
//           onPressed: saveForm,
//           icon: Icon(Icons.done),
//           label: Text('SAVE'),
//         ),
//       ];
//   Widget buildTitle() => TextFormField(
//         style: TextStyle(fontSize: 20),
//         validator: (val) => val!.isEmpty ? "Title can't be empty" : null,
//         decoration: InputDecoration(
//           hintText: "Add Title",
//         ),
//         onChanged: (val) {
//           schedTitle = val;
//           controller:
//           titleController;
//         },
//       );

//   // Widget buildDateTimePickers() => Column(
//   //       children: [
//   //         buildFrom(),
//   //         buildTo(),
//   //       ],
//   //     );

//   // Widget buildFrom() => buildHeader(
//   //       header: 'FROM',
//   //       child: Row(
//   //         children: [
//   //           Expanded(
//   //             flex: 2,
//   //             child: buildDropdownField(
//   //               text: EventUtils.toDate(fromDate),
//   //               onClicked: () => pickFromDateTime(pickDate: true),
//   //             ),
//   //           ),
//   //           Expanded(
//   //             child: buildDropdownField(
//   //               text: EventUtils.toTime(fromDate),
//   //               onClicked: () => pickFromDateTime(pickDate: false),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     );

//   // Widget buildTo() => buildHeader(
//   //       header: 'TO',
//   //       child: Row(
//   //         children: [
//   //           Expanded(
//   //             flex: 2,
//   //             child: buildDropdownField(
//   //               text: EventUtils.toDate(toDate),
//   //               onClicked: () => pickToDateTime(pickDate: true),
//   //             ),
//   //           ),
//   //           Expanded(
//   //             child: buildDropdownField(
//   //               text: EventUtils.toTime(toDate),
//   //               onClicked: () => pickToDateTime(pickDate: false),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     );

//   // Future pickFromDateTime({required bool pickDate}) async {
//   //   final date = await pickDateTime(fromDate, pickDate: pickDate);
//   //   if (date == null) return;

//   //   if (date.isAfter(toDate)) {
//   //     toDate =
//   //         DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
//   //   }

//   //   setState(() => fromDate = date);
//   // }

//   // Future pickToDateTime({required bool pickDate}) async {
//   //   final date = await pickDateTime(
//   //     toDate,
//   //     pickDate: pickDate,
//   //     firstDate: pickDate ? fromDate : null,
//   //   );
//   //   if (date == null) return;

//   //   setState(() => toDate = date);
//   // }

//   // Future<DateTime?> pickDateTime(
//   //   DateTime initialDate, {
//   //   required bool pickDate,
//   //   DateTime? firstDate,
//   // }) async {
//   //   if (pickDate) {
//   //     final date = await showDatePicker(
//   //       context: context,
//   //       initialDate: initialDate,
//   //       firstDate: firstDate ?? DateTime(2015, 8),
//   //       lastDate: DateTime(2101),
//   //     );
//   //     if (date == null) return null;

//   //     final time =
//   //         Duration(hours: initialDate.hour, minutes: initialDate.minute);

//   //     return date.add(time);
//   //   } else {
//   //     final timeOfDay = await showTimePicker(
//   //       context: context,
//   //       initialTime: TimeOfDay.fromDateTime(initialDate),
//   //     );

//   //     if (timeOfDay == null) return null;

//   //     final date =
//   //         DateTime(initialDate.year, initialDate.month, initialDate.day);

//   //     final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
//   //     return date.add(time);
//   //   }
//   // }

//   // Widget buildDropdownField({
//   //   required String text,
//   //   required VoidCallback onClicked,
//   // }) =>
//   //     ListTile(
//   //       title: Text(text),
//   //       trailing: Icon(Icons.arrow_drop_down),
//   //       onTap: onClicked,
//   //     );

//   // Widget buildHeader({
//   //   required String header,
//   //   required Widget child,
//   // }) =>
//   //     Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
//   //         child,
//   //       ],
//   //     );
// }
