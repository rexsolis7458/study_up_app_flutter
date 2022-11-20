// import 'package:flutter/material.dart';
// import 'package:study_up_app/main_screens/group/q&a/feed.dart';

// import '../../../services/database.dart';

// class Posting extends StatefulWidget {
//   @override
//   _PostingState createState() => _PostingState();
// }

// class _PostingState extends State<Posting> {
//   final PostService _postService = PostService();
//   String text = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color: Colors.black54,
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () async {
//               _postService.savePost(text);
//               Navigator.pop(context);
//             },
//             child: Text(
//               'Post',
//               style: TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         child: new Form(child: TextFormField(
//           onChanged: (val) {
//             setState(() {
//               text = val;
//             });
//           },
//         )),
//       ),
//     );
//   }
// }
