import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool isloop;

  VideoPlayer({@required this.videoPlayerController, @required this.isloop});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.isloop,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   chewieController.dispose();
  // }
  //
  // @override
  // void initstate() {
  //   chewieController = ChewieController(
  //     videoPlayerController: widget.videoPlayerController,
  //     looping: widget.isloop,
  //     aspectRatio: 16 / 9,
  //     autoInitialize: true,
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: chewieController,
      ),
    );
  }
}

class VideoDisplay extends StatefulWidget {
  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(
      isloop: true,
      videoPlayerController: VideoPlayerController.asset('assets/v1.mp4'),
      // videoPlayerController: VideoPlayerController.network('https://www.youtube.com/watch?v=LrGubJqwUJ8&list=PLRT5VDuA0QGWzdanIdaO8A3h7CEAT2ROd&index=7'),
    );
  }
}
