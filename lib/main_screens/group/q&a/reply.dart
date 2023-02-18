import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:study_up_app/main_screens/group/q&a/posting.dart';
import 'package:study_up_app/models/post.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/userController.dart';
import '../../../helper/const.dart';
import '../../../services/database.dart';
import 'commentModel.dart';
import 'feed.dart';
import 'list.dart';

class Reply extends StatefulWidget {
  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  Stream? replyStream;

  ReplyService commentService = new ReplyService();

  Widget replyList() {
    return Container(
      child: StreamBuilder(
        stream: replyStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ReplyTile(
                      // imgUrl: snapshot.data.doc[index].data['quizImgurl'],
                      reply:
                          snapshot.data.docs[index].data()['replyDescription'],
                      replyId: snapshot.data.docs[index].data()['replyId'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    commentService.getRepliesData().then((val) {
      setState(() {
        replyStream = val;
      });
    });
    super.initState();
  }

  final _qFormKey = GlobalKey<FormState>();
  // late String quizImgurl, quizTitle, quizDescription, quizId;
  late String replyDescription, replyId;

  ReplyService replyService = new ReplyService();

  bool _isLoading = false;

  createReply() async {
    if (_qFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      replyId = randomAlphaNumeric(16);

      Map<String, String> replyMap = {
        // 'quizImgurl': quizImgurl,
        'replyId': replyId,
        'replyDescription': replyDescription
      };

      await replyService.addReplyData(replyId, replyMap).then(
        (value) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Object? args = ModalRoute.of(context)?.settings.arguments;

    return FutureProvider.value(
        value: replyService.replyList(),
        initialData: null,
        child: Container(
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: Colors.black54,
                  ),
                  actions: <Widget>[
                    // TextButton(
                    //   onPressed: () async {
                    //     createReply();
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text(
                    //     'Post',
                    //     style: TextStyle(color: Colors.black54),
                    //   ),
                    // ),
                  ],
                ),
                body: _isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        child: Column(children: [
                        Expanded(
                          child: replyList(),
                        ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                        // TextButton(
                        //   onPressed: () async {
                        //     print('s');
                        //     Navigator.pop(context);
                        //   },
                        Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isLoading
                                    ? Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Form(
                                        key: _qFormKey,
                                        child: Container(
                                          color: Colors.grey[200],
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // TextFormField(
                                              //   validator: (val) =>
                                              //       val!.isEmpty ? "Quiz Image Url can't be empty" : null,
                                              //   decoration: InputDecoration(
                                              //     hintText: "Quiz Image Url",
                                              //   ),
                                              //   onChanged: (val) {
                                              //     quizImgurl = val;
                                              //   },
                                              // ),
                                              const SizedBox(
                                                height: 10,
                                              ),

                                              TextFormField(
                                                validator: (val) => val!.isEmpty
                                                    ? "Reply"
                                                    : null,
                                                decoration: InputDecoration(
                                                  icon: new Icon(
                                                    Icons.chat_bubble_outline,
                                                  ),
                                                  suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                      ),
                                                      onPressed: () async {
                                                        createReply();
                                                        // replyList();
                                                      }),
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 30,
                                                          bottom: 11,
                                                          top: 11,
                                                          right: 15),
                                                  hintText: "Reply",
                                                ),
                                                onChanged: (val) {
                                                  replyDescription = val;
                                                },
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ]),
                        )
                      ])))));
  }
}

class ReplyTile extends StatelessWidget {
  //final String imgUrl;
  final String reply;
  final String replyId;

  // QuizTile({required this.imgUrl, required this.title, required this.desc});
  ReplyTile({required this.reply, required this.replyId});

  @override
  Widget build(BuildContext context) =>
      GetX<UserController>(initState: (_) async {
        Get.find<UserController>().user =
            await Database().getUser(Get.find<AuthController>().reference.id);
      }, builder: (_) {
        if (_.user.id != null) {
          return SingleChildScrollView(
              child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // child: Image.network(
                      //   imgUrl,
                      //   width: MediaQuery.of(context).size.width - 48,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.only(left: 30, bottom: 11, top: 11, right: 15),
                  //   decoration: BoxDecoration(
                  //     // borderRadius: BorderRadius.circular(8),
                  //     color: BGColor,
                  //   ),
                  //   // color: Colors.black26,
                  //   alignment: Alignment.center,
                  //   child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         // ClipRRect(
                  //         //   borderRadius: BorderRadius.circular(8),
                  //         //   child: Image.network(
                  //         //     imgUrl,
                  //         //     width: MediaQuery.of(context).size.width - 48,
                  //         //     fit: BoxFit.cover,
                  //         //   ),
                  //         // ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_.user.email}',
                              style: TextStyle(
                                  color: MainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            reply,
                            // style: TextStyle(
                            //     color: MainColor,
                            //     fontSize: 17,
                            //     fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: new Icon(
                                  Icons.thumb_up_alt_outlined,
                                ),
                                onPressed: () => null),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ));
        } else {
          return const Text(
            'loading.....',
            textAlign: TextAlign.center,
          );
        }
      });
}
