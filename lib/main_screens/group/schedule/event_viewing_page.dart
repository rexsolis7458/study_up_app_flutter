// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../utils/event_utils.dart';
// import 'package:study_up_app/main_screens/group/schedule/event_editing_page.dart';
// import 'package:study_up_app/provider/event_provider.dart';

// import 'package:study_up_app/provider/event_provider.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';


// class EventViewingPage extends StatelessWidget {
//   final Event event;

//   const EventViewingPage({
//     Key? key,
//     required this.event,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         leading: CloseButton(),
//         actions: buildViewingActions(context, event),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(32),
//         children: <Widget>[
//           buildDateTime(event),
//           SizedBox(height: 32),
//           Text(
//             event.title,
//           ),
//           const SizedBox(height:24),
//           Text(event.description,),
//         ],
//       ),
    
//     );
//     Widget buildDateTime(Event event) {
//       return Column(
//         children: [
//           buildDate(event.isAllDay ? 'All-Day' : 'From', event.from),
//           if (!event.isAllDay) buildDate('To', event.to),
//         ],
//       );
//     }

//     // Widget buildDate(String title, DateTime date){

//     // }
//     List<Widget> buildViewingActions(BuildContext context, Event event){
//       IconButton(
//         icon: Icon(Icons.edit),
//       onPressed: ()=> Navigator.of(context).pushReplacement(
// MaterialPageRoute(
//   builder: (context)=> EventEditingPage(event: event),
//   ),
//       ),
//       );
//        IconButton(
//         icon: Icon(Icons.delete),
//       onPressed: (){
//         final provider = Provider.of<EventProvider>(context, listen: true);
        
//         provider.deleteEvent(event);

//       }
//   ),
   
//     }
  
// }
