import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/schedule/event.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'calendar.dart';

class Sched extends StatefulWidget {
  final DocumentSnapshot group;

  Sched(this.group);

  @override
  _SchedState createState() => _SchedState();
}

class _SchedState extends State<Sched> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream? schedStream;

  ScheduleService scheduleService = new ScheduleService();

  Widget schedList() {
    return Container(
      child: StreamBuilder(
        stream: schedStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return SchedTile(
                      title: snapshot.data.docs[index].data()['schedTitle'],
                      schedId: snapshot.data.docs[index].data()['schedId'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    scheduleService.getScheduleData().then((val) {
      setState(() {
        schedStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
          ];
        },
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection('Events/${widget.group['groupName']}/events')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Define firstDay and lastDay here
            DateTime now = DateTime.now();
            DateTime firstDay = DateTime(now.year, now.month, 1);
            DateTime lastDay = DateTime(now.year, now.month + 1, 0);

            final List<Event> events = snapshot.data!.docs
                .map((document) => Event.fromFirestore(document))
                .toList();

            return ListView.builder(
              itemCount: (events.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                final int eventIndex = index * 2;
                return Row(
                  children: [
                    Expanded(
                      child: events.length > eventIndex
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 16,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                events[eventIndex].title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${events[eventIndex].date.day}/${events[eventIndex].date.month}/${events[eventIndex].date.year}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            events[eventIndex].description,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: _buildEventTile(events[eventIndex]),
                            )
                          : SizedBox(),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: events.length > eventIndex + 1
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 16,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                events[eventIndex + 1].title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${events[eventIndex + 1].date.day}/${events[eventIndex + 1].date.month}/${events[eventIndex + 1].date.year}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            events[eventIndex + 1].description,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: _buildEventTile(events[eventIndex + 1]),
                            )
                          : SizedBox(),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Container(
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Cal(
                  group: widget.group,
                ),
              ),
            );
          },
          label: Text('Create Schedule'),
        ),
      ),
    );
  }
}

class SchedTile extends StatelessWidget {
  final String title;
  final String schedId;

  SchedTile({
    required this.title,
    required this.schedId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, top: 10, left: 8, right: 8),
      height: 150,
      width: 190,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                title,
                style: TextStyle(
                    color: MainColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
            ]),
          )
        ],
      ),
    );
  }
}

Widget _buildEventTile(Event event) {
  return Card(
    color: BGColor,
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              event.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: Text(
              '${event.date.day}/${event.date.month}/${event.date.year}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
