// import 'package:charuvidya/Temp/video_items.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[100],
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Flutter Video Player Demo'),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: <Widget>[
//           VideoItems(
//             videoPlayerController: VideoPlayerController.asset(
//               'assets/v1.mp4',
//             ),
//             looping: false,
//             autoplay: false,
//           ),
//           VideoItems(
//             videoPlayerController: VideoPlayerController.network(
//                 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
//             ),
//             looping: false,
//             autoplay: true,
//           ),
//         ],
//       ),
//     );
//   }
// }