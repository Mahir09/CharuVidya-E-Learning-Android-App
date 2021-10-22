import 'dart:convert';
import 'package:charuvidya/Classes/CourseSection.dart';
import 'package:charuvidya/Classes/CourseSession.dart';
import 'package:charuvidya/Components/constatns.dart' as color;
import 'package:charuvidya/Components/video_items.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class CourseDetail extends StatefulWidget {
  final courseData;

  const CourseDetail({Key key, this.courseData}) : super(key: key);

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  int courseId = 0;
  String url;
  bool _isPlaying = false;
  bool _dispose = false;
  int _isPlayingIndex = 0;
  VideoPlayerController _controller;

  String IDtoken = "";
  final storage = new UserSecureStorage(key: "id_token");

  Map<String, dynamic> data;

  List videoInfo = [];

  _initData() async {
    final jwt = await storage.getIdToken();
    IDtoken = jwt;
    final response = await http.get(
        "http://117.239.83.200:9000/api/course/${widget.courseData["id"]}/course-sections-sessions",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $IDtoken',
        });
    print("RRRRRRRRRRRRRRRRRR  >>>> ${response.body}");
    if (response.body.isNotEmpty) {
      setState(() {
        data = json.decode(response.body);
      });
    }
    print("RRRRRRRRRRRRRRRRRR  >>>> ${data}");

    data.forEach((key, value) {
      setState(() {
        videoInfo.addAll(value);
      });
    });
    print("SSSSSSSSSSSSSSSSSSSS >> $videoInfo");
  }

  @override
  void initState() {
    // print(
    //     "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA >>>>>>>>>  ${widget.courseData}");
    super.initState();
    _initData();
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
    return (data != null)
        ? DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.share_outlined,
                          size: 26.0,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 26.0,
                        ),
                      )),
                ],
              ),
              body: Column(
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    child: _controller != null
                        ? _playView(context)
                        : _onTapVideo(0),
                  ),
                  SizedBox(
                    height: 75,
                    child: AppBar(
                      bottom: TabBar(
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.featured_play_list_outlined,
                              size: 18,
                            ),
                            text: "Playlist",
                          ),
                          Tab(
                            icon: Icon(
                              Icons.details_outlined,
                              size: 18,
                            ),
                            text: "Description",
                          ),
                          Tab(
                            icon: Icon(
                              Icons.link_outlined,
                              size: 18,
                            ),
                            text: "Resources",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(70))),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    itemCount: videoInfo.length,
                                    itemBuilder: (_, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _onTapVideo(index);
                                          debugPrint(index.toString());
                                        },
                                        child: _listView(index),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              videoInfo[_isPlayingIndex]["sessionDescription"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  (videoInfo[_isPlayingIndex]
                                              ["sessionResource"]) !=
                                          null
                                      ? videoInfo[_isPlayingIndex]
                                          ["sessionResource"]
                                      : "No Resources Available",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  (videoInfo[_isPlayingIndex]["quizLink"]) !=
                                          null
                                      ? videoInfo[_isPlayingIndex]["quizLink"]
                                      : "No Quiz's Available",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  _playView(BuildContext context) {
    if (_controller == null) {
      _controller = VideoPlayerController.network(videoInfo[0]["sessionVideo"]);
    }
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return VideoItems(
        videoPlayerController: controller,
      );
    } else {
      return AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(child: CircularProgressIndicator()));
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
    print("IIIIIIIIIIIIIIIIIIIII  >> ${videoInfo[index]["sessionVideo"]}");
    final controller =
        VideoPlayerController.network(videoInfo[index]["sessionVideo"]);
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
    return (_isPlayingIndex == index)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Card(
              elevation: 5,
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[800], width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 95,
                width: 200,
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                "assets/c.jpeg",
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
                              videoInfo[index]["sessionTitle"]
                                          .toString()
                                          .length >
                                      25
                                  ? videoInfo[index]["sessionTitle"]
                                          .toString()
                                          .substring(0, 25) +
                                      '...'
                                  : videoInfo[index]["sessionTitle"],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 3),
                            //   child: Text(
                            //     videoInfo[index]["time"],
                            //     style:
                            //         TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 95,
              width: 200,
              padding: EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                              "assets/c.jpeg",
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
                            videoInfo[index]["sessionTitle"].toString().length >
                                    25
                                ? videoInfo[index]["sessionTitle"]
                                        .toString()
                                        .substring(0, 25) +
                                    '...'
                                : videoInfo[index]["sessionTitle"],
                            style: TextStyle(fontSize: 18),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 3),
                          //   child: Text(
                          //     videoInfo[index]["time"],
                          //     style:
                          //         TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

// class CourseDetail extends StatefulWidget {
//   String name = ' ';
//   String iname = ' ';
//   String ratings = ' ';
//   String enrolledno = ' ';
//   String price = ' ';
//   String img = ' ';
//   CourseDetail(this.name, this.iname, this.ratings, this.enrolledno, this.price,
//       this.img);
//
//   @override
//   _CourseDetailState createState() => _CourseDetailState(this.name, this.iname,
//       this.ratings, this.enrolledno, this.price, this.img);
// }
//
// class _CourseDetailState extends State<CourseDetail> {
//   String name;
//   String iname;
//   String ratings;
//   String enrolledno;
//   String price;
//   String img;
//   _CourseDetailState(this.name, this.iname, this.ratings, this.enrolledno,
//       this.price, this.img);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Colors.black,
//         actions: [
//           // IconButton(
//           //   icon: Icon(FontAwesomeIcons.backward),
//           //   onPressed: () {
//           //     Navigator.of(context).push(
//           //       MaterialPageRoute(
//           //         fullscreenDialog: false,
//           //         builder: (context) => Home(),
//           //       ),
//           //     );
//           //       Navigator.pushReplacement(
//           //         context,
//           //         PageTransition(
//           //             child: Home(), type: PageTransitionType.bottomToTop),
//           //       );
//           //   },
//           // ),
//           IconButton(
//             icon: Icon(FontAwesomeIcons.share),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(FontAwesomeIcons.shoppingCart),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text(
//                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vulputate, nisl eget tempus dapibus, erat massa pulvinar risus, in feugiat erat nunc a tortor. Duis convallis porttitor fringilla. Praesent nec egestas tortor, a faucibus magna.",
//                   style: TextStyle(
//                     color: Colors.grey.shade700,
//                     fontSize: 15,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.0),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 4.0),
//                             child: Icon(
//                               Icons.star,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Text(
//                               "Created By $iname",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8.0),
//                               border: Border.all(color: Colors.black),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Icon(
//                                     Icons.star,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Text(
//                                     ratings,
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8.0),
//                               border: Border.all(color: Colors.black),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Icon(
//                                     Icons.star,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Text(
//                                     enrolledno + " Enrolled",
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8.0),
//                               border: Border.all(color: Colors.black),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Icon(
//                                     Icons.star,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(5.0),
//                                   child: Text(
//                                     "10 Total Hours",
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // Get.dialog(
//                   //   Container(
//                   //     child: VideoDisplay(),
//                   //   )
//                   // );
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       fullscreenDialog: false,
//                       builder: (context) => Container(
//                               child: VideoDetail(),
//                             ),
//                     ),
//                   );
//                   // Navigator.pushReplacement(
//                   //   context,
//                   //   PageTransition(
//                   //     child: Container(
//                   //       child: VideoDisplay(),
//                   //     ),
//                   //     type: PageTransitionType.leftToRight,
//                   //   ),
//                   // );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                   child: SizedBox(
//                     height: 200,
//                     width: 400,
//                     child: Stack(
//                       children: [
//                         Container(
//                           // height: 200,
//                           // width: 400,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: AssetImage('$img'),
//                                   fit: BoxFit.cover,
//                                   colorFilter: ColorFilter.mode(
//                                       Colors.black45, BlendMode.darken))),
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: Positioned(
//                             child: Icon(
//                               Icons.play_circle_fill,
//                               color: Colors.white,
//                               size: 70,
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Positioned(
//                             child: Text(
//                               'Preview This Course',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 22),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // Text(
//               //   'Instructor : ' + iname,
//               //   style: TextStyle(
//               //     color: Colors.black,
//               //     fontSize: 20,
//               //     fontWeight: FontWeight.bold,
//               //   ),
//               // ),
//               // Text(
//               //   'Ratings : ' + ratings,
//               //   style: TextStyle(
//               //     color: Colors.black,
//               //     fontSize: 20,
//               //     fontWeight: FontWeight.bold,
//               //   ),
//               // ),
//               // Text(
//               //   'Enrolled Students : ' + enrolledno,
//               //   style: TextStyle(
//               //     color: Colors.black,
//               //     fontSize: 20,
//               //     fontWeight: FontWeight.bold,
//               //   ),
//               // ),
//               Row(
//                 children: [
//                   Icon(
//                     FontAwesomeIcons.rupeeSign,
//                     color: Colors.black,
//                     size: 22,
//                   ),
//                   Text(
//                     price,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Container(
//                   width: 400,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Start Now',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: 50,
//                       // width: 180,
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Center(
//                           child: Text(
//                             'Add To Cart',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 50,
//                       // width: 180,
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Center(
//                           child: Text(
//                             'Add To Wishlist',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
