// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({Key? key}) : super(key: key);

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   final AgoraClient _client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//     appId: '0a8637866ab447e5917d21ab2c681f9c',
//     channelName: 'study_up',
//     tempToken:
//         '007eJxTYDjn9SPz5ybOiY36fqWpryT7BWLZvSom5acp/jBTXuFs56/AYJBoYWZsbmFmlphkYmKeamppaJ5iZJiYZJRsZmGYZpmcxeCS0hDIyHD+qzAzIwMjAwsQg/hMYJIZTLKASQ6G4pLSlMr40gIGBgA0NyD1',
//   ));

//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//   }

//   Future<void> _initAgora() async {
//     await _client.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text('Video Call'),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(
//                 client: _client,
//                 layoutType: Layout.floating,
//                 showNumberOfUsers: true,
//               ),
//               AgoraVideoButtons(
//                 client: _client,
//                 enabledButtons: const [
//                   BuiltInButtons.toggleCamera,
//                   BuiltInButtons.callEnd,
//                   BuiltInButtons.toggleMic,
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
