import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_up_app/main_screens/group/groupChat/vidCall.dart';
import 'package:study_up_app/models/users.dart';

class GroupChat extends StatefulWidget {
  final DocumentSnapshot group;

  GroupChat(this.group);

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final TextEditingController _textController = TextEditingController();
  

  Future<List<Map<String, dynamic>>> _getMessageDataList(
      List<QueryDocumentSnapshot<Object?>> messageDocs) async {
    var messageDataList = <Map<String, dynamic>>[];
    for (var messageDoc in messageDocs) {
      var messageData = messageDoc.data() as Map<String, dynamic>;
      var senderDocRef = messageData['senderDoc'] as DocumentReference?;
      if (senderDocRef != null) {
        var senderDocSnapshot = await senderDocRef.get();
        var sender = UserModel.fromDocumentSnapshot(doc: senderDocSnapshot);
        messageData['sender'] = sender;
        messageData['message'] = messageData['messages'];
        if (messageData.containsKey('senderName')) {
          var senderName = messageData['senderName'];
          messageData['senderName'] =
              senderName ?? (sender.firstname! + ' ' + sender.lastname!);
        } else {
          messageData['senderName'] =
              sender.firstname! + ' ' + sender.lastname!;
        }
        messageDataList.add(messageData);
      }
    }
    return messageDataList;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
final uid = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
        actions: [
          IconButton(
  onPressed: () => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => VideoCall()),
  ),
  icon: const Icon(Icons.video_camera_front),
),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('group_chats')
                  .doc(widget.group['groupName'])
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  // Add this new check
                  return Center(child: Text('No messages yet'));
                } else {
                  var messageDataList = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messageDataList.size,
                    itemBuilder: (context, index) {
                      var messageData = messageDataList.docs[index];
                      print(messageData);
                      var senderName = messageData['senderName'];
                      var isMe = messageData['senderId'] ==
                          FirebaseAuth.instance.currentUser!.uid;
                      return Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Text(
                              senderName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: Text(
                                messageData['messages'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isMe ? Colors.black : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _sendMessage() async {
    String message = _textController.text.trim();
    if (message.isNotEmpty) {
      // Get the current user's information
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final senderName = userDoc['firstname'] + ' ' + userDoc['lastname'];

      // Add the message to the group chat
      FirebaseFirestore.instance
          .collection('group_chats')
          .doc(widget.group['groupName'])
          .collection('messages')
          .add({
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'senderName': senderName,
        'messages': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _textController.clear();
    }
  }
}
