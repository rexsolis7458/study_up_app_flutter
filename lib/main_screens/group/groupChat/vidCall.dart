import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_up_app/helper/settings.dart';
import 'package:wakelock/wakelock.dart';

import '../../../controller/call_controller.dart';

class VideoCall extends StatefulWidget {
  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final callCon = Get.put(CallController());

  @override
  void initState() {
    super.initState();
    Wakelock.enable(); // Turn on wakelock feature till call is running
  }

  @override
  void dispose() {
    Wakelock.disable(); // Turn off wakelock feature after call end
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Center(
              child: callCon.localUserJoined == true
                  ? callCon.videoPaused == true
                      ? Container(
                          color: Theme.of(context).primaryColor,
                          child: Center(
                              child: Text(
                            "Remote Video Paused",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.white70),
                          )))
                      : AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: callCon.engine,
                            canvas: VideoCanvas(
                              uid: callCon.myremoteUid.value,
                            ),
                            connection: const RtcConnection(channelId: channelId),
                          ),
                        )
                  : const Center(
                      child: Text(
                        'No Remote',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
            if (callCon.localUserJoined.value)
              GridView.count(
                padding: EdgeInsets.only(top: 150),
                crossAxisCount: 2, // Change this value to modify the number of columns
                children: List.generate(callCon.remoteUids.length, (index) {
                  final remoteUid = callCon.remoteUids[index];
                  return AgoraVideoView(
                    key: ValueKey(remoteUid),
                    controller: VideoViewController.remote(
                      rtcEngine: callCon.engine,
                      canvas: VideoCanvas(uid: remoteUid),
                      connection: const RtcConnection(channelId: channelId),
                    ),
                  );
                }),
              ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          callCon.onToggleMute();
                        },
                        child: Icon(
                          callCon.muted.value ? Icons.mic : Icons.mic_off,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          callCon.onCallEnd();
                        },
                        child: const Icon(
                          Icons.call,
                          size: 35,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          callCon.onVideoOff();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Icon(
                                Icons.photo_camera_front,
                                size: 25,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          callCon.onSwitchCamera();
                        },
                        child: const Icon(
                          Icons.switch_camera,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}