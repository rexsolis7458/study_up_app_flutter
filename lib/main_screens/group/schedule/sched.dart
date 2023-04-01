import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'sched_sample.dart';

class Sched extends StatefulWidget {
  final DocumentSnapshot group;

  Sched(this.group);

  @override
  _SchedState createState() => _SchedState();
}

class _SchedState extends State<Sched> {
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
                      // desc:
                      //     snapshot.data.docs[index].data()['schedDescription'],
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
      body: SchedTile(
        // desc: 'desc',
        schedId: 'schedId',
        title: 'title',
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Cal(
                      group: widget.group,
                    )),
          );
        },
      ),
    );
  }
}

class SchedTile extends StatelessWidget {
  final String title;
  // final String desc;
  final String schedId;

  SchedTile({
    required this.title,
    required this.schedId,
    //required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, top: 10, left: 8, right: 8),
      height: 150,
      width: 190,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
          ),
          Container(
            // color: ButtonColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: BGColor,
            ),
            // color: Colors.black26,
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

              // Text(
              //   desc,
              //   style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 14,
              //       fontWeight: FontWeight.w400),
              // )
            ]),
          )
        ],
      ),
    );
  }
}
