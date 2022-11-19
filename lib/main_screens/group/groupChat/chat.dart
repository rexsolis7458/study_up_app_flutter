import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/helper/const.dart';

class GroupChat extends StatelessWidget {
  Map<String, dynamic>? userMap;
  late final String chatRoomId;

  GroupChat({required this.chatRoomId,Key? key}): super(key: key);

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection("users").doc(userMap?['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(userMap?['name']),
                    Text(
                      snapshot.data!['status'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messagesTile(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            // suffixIcon: IconButton(
                            //   onPressed: () => getImage(),
                            //   icon: Icon(Icons.photo),
                            // ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //   centerTitle: true,
      //   elevation: 0,
      //   title: Text(
      //     'Group Chat',
      //     style: TextStyle(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       //  bottomSheet:
      //       Container(
      //         height: size.height / 1.27,
      //         width: size.width,
      //         child: StreamBuilder<QuerySnapshot>(
      //           stream: _firestore
      //           builder: context,snapshot){

      //           }
      //         // child: ListView.builder(
      //         //     itemCount: dummyChatList.length,
      //         //     itemBuilder: (context, index) {
      //         //       return messageTile(size, dummyChatList[index]
      //         //           // isByMe: true,
      //         //           // message: '',
      //         //           );
      //         //     }),
      //       ),
      //       Container(
      //         height: size.height / 10,
      //         width: size.width,
      //         alignment: Alignment.center,
      //         child: Container(
      //           height: size.height / 12,
      //           width: size.width / 1.1,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 height: size.height / 17,
      //                 width: size.width / 1.3,
      //                 decoration: BoxDecoration(
      //                     color: Color(0xffF4F5FA),
      //                     borderRadius: BorderRadius.circular(25)),
      //                 child: TextField(
      //                   // controller: _message,
      //                   decoration: InputDecoration.collapsed(
      //                       hintText: 'Aa',
      //                       hintStyle: TextStyle(
      //                         fontSize: 16,
      //                         fontWeight: FontWeight.w500,
      //                       )),
      //                 ),
      //               ),
      //               IconButton(
      //                 icon: Icon(Icons.send),
      //                 onPressed: () {},
      //               ),
      //             ],
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

// class MessageTile extends StatelessWidget {
//   final bool isByMe;
//   final String message;

//   MessageTile({required this.isByMe, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         bottom: 16,
//       ),
//       alignment: isByMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         decoration: BoxDecoration(
//             color: isByMe ? SecondaryColor : SecondaryColor,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//                 bottomLeft: isByMe ? Radius.circular(30) : Radius.circular(30),
//                 bottomRight:
//                     isByMe ? Radius.circular(30) : Radius.circular(30))),
//         padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         child: Container(
//           constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 2 / 3),
//           child: Text(
//             'kuuhd',
//             // message,
//             style: TextStyle(
//               color: isByMe ? Colors.white : SecondaryColor,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

  Widget messagesTile(
      Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
