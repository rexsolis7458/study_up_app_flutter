import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/q&a/feed.dart';

class Replies extends StatefulWidget {
  @override
  _RepliesState createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          Expanded(
            child: CommentTile(
              comId: 'comId',
              comment: 'comment',
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Form(
                    child: CommentTile(
                  comId: '',
                  comment: '',
                )),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () async {
                    print('s');
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Reply',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
