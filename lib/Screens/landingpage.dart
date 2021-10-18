import 'package:charuvidya/Screens/DetailSection/VideosDetail.dart';
import 'package:charuvidya/Screens/HomeScreen/HomeScreen.dart';
import 'package:charuvidya/Screens/SignIn/Signin.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Landing Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      // body: Container(
      //   child: Center(
      //     child: SizedBox(
      //       height: 400,
      //       width: 400,
      //       child: Image.asset(
      //         'images/landingpage-bg.png',
      //         fit: BoxFit.fitHeight,
      //         colorBlendMode: BlendMode.darken,
      //         color: Colors.black54,
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: () {
                // Get.to(HomeScreen());
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => HomeScreen(),
                    // builder: (context) => VideoDetail(),
                  ),
                );
                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       child: HomeScreen(),
                //       type: PageTransitionType.bottomToTop),
                // );
              },
              child: Text(
                'Browse',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 20.0,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) => SignIn(),
                  ),
                );
                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       child: SignIn(), type: PageTransitionType.bottomToTop),
                // );
              },
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
