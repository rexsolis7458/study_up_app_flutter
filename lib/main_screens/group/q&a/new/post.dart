// import 'package:flutter/material.dart';
// import 'package:study_up_app/services/db.dart';

// import '../../../../helper/const.dart';

// class Post extends StatefulWidget {
//   @override
//   _PostState createState() => _PostState();
// }

// class _PostState extends State<Post> {
//   final PostService _postService = PostService();
//   String text = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColor,
//         centerTitle: true,
//         elevation: 0,
//         title: Text(
//           'My Groups',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: <Widget>[
//           GestureDetector(
//             onTap: () async {
//               _postService.savePost(text);
//               Navigator.pop(context);
//             },
//             child: Text('Post'),
//           ),
//         ],
//       ),
//       body: Container(
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//           child: new Form(child: TextFormField(
//             onChanged: (val) {
//               setState(() {
//                 text = val;
//               });
//             },
//           ))),
//     );
//   }
// }
