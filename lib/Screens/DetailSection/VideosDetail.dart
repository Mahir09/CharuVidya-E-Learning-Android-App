import 'dart:convert';

import 'package:charuvidya/Components/constatns.dart' as color;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoDetail extends StatefulWidget {
  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  List videoInfo = [];
  bool _playArea = false;
  bool _isPlaying = false;
  bool _dispose = false;
  int _isPlayingIndex = -1;
  VideoPlayerController _controller;



  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
    //_onTapVideo(-1);
  }

  @override
  void dispose() {
    _dispose = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.AppColor.gradientFirst.withOpacity(0.9),
                color.AppColor.gradientSecond
              ],
              begin: const FractionalOffset(0.0, 0.4),
              end: Alignment.topRight,
            )),
        child: Column(
          children: [
            _playArea == false
                ? Container(
                padding:
                const EdgeInsets.only(top: 70, left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                                Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios,
                              size: 20,
                              color: color.AppColor.secondPageIconColor),
                        ),
                        Expanded(child: Container()),
                        Icon(Icons.info_outline,
                            size: 20,
                            color: color.AppColor.secondPageIconColor),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Java Programming Language",
                      style: TextStyle(
                          fontSize: 25,
                          color: color.AppColor.secondPageTitleColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "By Minal",
                      style: TextStyle(
                          fontSize: 25,
                          color: color.AppColor.secondPageTitleColor),
                    ),

                  ],
                ))
                : Container(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    padding: const EdgeInsets.only(
                        top: 50, left: 30, right: 30),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _playArea=false;
                            });
                          },
                          child: Icon(
                            Icons.arrow_back_sharp,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _playView(context),
                  _controlView(context),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.only(topRight: Radius.circular(70))),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: videoInfo.length,
                        itemBuilder: (_, int index) {
                          return GestureDetector(
                            onTap: () {
                              _onTapVideo(index);
                              debugPrint(index.toString());
                              setState(() {
                                if (_playArea == false) {
                                  _playArea = true;
                                }
                              });
                            },
                            child: _listView(index),
                            // child: Container(
                            //   height: 135,
                            //   color: Colors.redAccent,
                            //   width: 200,
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         children: [
                            //           Container(
                            //             width: 80,
                            //             height: 80,
                            //             decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(10),
                            //               image: DecorationImage(
                            //                 image: AssetImage(
                            //                   videoInfo[index]["thumbnail"],
                            //                 ),
                            //                 fit: BoxFit.cover,
                            //               ),
                            //             ),
                            //           ),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 videoInfo[index]["title"],
                            //                 style: TextStyle(
                            //                     fontSize: 18,
                            //                     fontWeight:
                            //                         FontWeight.bold),
                            //               ),
                            //               SizedBox(
                            //                 height: 10,
                            //               ),
                            //               Padding(
                            //                 padding: const EdgeInsets.only(
                            //                     top: 3),
                            //                 child: Text(
                            //                   videoInfo[index]["time"],
                            //                   style: TextStyle(
                            //                       fontSize: 18,
                            //                       fontWeight:
                            //                           FontWeight.bold),
                            //                 ),
                            //               ),
                            //             ],
                            //           )
                            //         ],
                            //       ),
                            //       // Row(
                            //       //   children: [
                            //       //     Container(
                            //       //       width: 80,
                            //       //       height: 20,
                            //       //       decoration: BoxDecoration(
                            //       //         color: Color(0xFFeaeefc),
                            //       //         borderRadius: BorderRadius.circular(10),
                            //       //       ),
                            //       //     )
                            //       //   ],
                            //       // )
                            //     ],
                            //   ),
                            // ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _controlView(BuildContext context) {
    final noMute = (_controller?.value?.volume??0)>0;
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: color.AppColor.secondPageContainerGradient1stColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(50, 0, 0, 0),
                    )
                  ],
                ),
                child: Icon(
                  noMute ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: (){
              if(noMute){
                _controller?.setVolume(0);
              }
              else{
                _controller?.setVolume(1.0);
              }
              setState(() {

              });
            },
          ),
          FlatButton(
              onPressed: () async {
                final index = _isPlayingIndex - 1;
                if (index >= 0 && videoInfo.length >= 0) {
                  _onTapVideo(index);
                } else {
                  Get.snackbar("Video List", "",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: Icon(
                        Icons.face,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: color.AppColor.gradientSecond,
                      colorText: Colors.white,
                      messageText: Text(
                        "No more videos to play",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ));
                }
              },
              child: Icon(
                Icons.fast_rewind,
                size: 36,
                color: Colors.white,
              )),
          FlatButton(
              onPressed: () async {
                if (_isPlaying) {
                  setState(() {
                    _isPlaying = false;
                  });
                  _controller?.pause();
                } else {
                  setState(() {
                    _isPlaying = true;
                  });
                  _controller?.play();
                }
              },
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 36,
                color: Colors.white,
              )),
          FlatButton(
              onPressed: () async {
                final index = _isPlayingIndex + 1;
                if (index <= videoInfo.length - 1) {
                  _onTapVideo(index);
                } else {
                  Get.snackbar("Video List", "",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: Icon(
                        Icons.face,
                        size: 30,
                        color: Colors.white,
                      ),
                      backgroundColor: color.AppColor.gradientSecond,
                      colorText: Colors.white,
                      messageText: Text(
                        "No more videos to play",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ));
                }
              },
              child: Icon(
                Icons.fast_forward,
                size: 36,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return AspectRatio(
          aspectRatio: 16 / 9, child: Center(child: Text("Wait")));
    }
  }

  var _onUpadteControllerTime;
  void _onControllerUpdate() async {
    if (_dispose) {
      return;
    }
    _onUpadteControllerTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpadteControllerTime > now) {
      return;
    }
    _onUpadteControllerTime = now + 500;
    final controller = _controller;
    if (controller == null) {
      return;
    }
    if (!controller.value.isInitialized) {
      return;
    }
    final playing = controller.value.isPlaying;
    _isPlaying = playing;
  }

  _onTapVideo(int index) {
    final controller =
    VideoPlayerController.network(videoInfo[index]["videoUrl"]);
    final old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_onControllerUpdate);
      old.pause();
    }
    setState(() {});
    controller
      ..initialize().then((_) {
        old?.dispose();
        _isPlayingIndex = index;
        controller.addListener(_onControllerUpdate);
        controller.play();
        setState(() {});
      });
  }

  _listView(int index) {
    return Container(
      height: 120,
      // color: Colors.redAccent,
      width: 200,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                      videoInfo[index]["thumbnail"],
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoInfo[index]["title"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      videoInfo[index]["time"],
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

