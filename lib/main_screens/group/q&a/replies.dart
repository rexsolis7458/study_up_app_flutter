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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        actions: <Widget>[
          // TextButton(
          //   onPressed: () async {
          //     createComment();
          //     Navigator.pop(context);
          //   },
          //   child: Text(
          //     'Post',
          //     style: TextStyle(color: Colors.black54),
          //   ),
          // ),
        ],
      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: TextFormField(
                    validator: (val) => val!.isEmpty ? "Reply" : null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 30, bottom: 11, top: 11, right: 15),
                      hintText: "Reply",
                    ),
                    onChanged: (val) {
                      // commentDescription = val;
                      Navigator.pop(context);
                    },
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
