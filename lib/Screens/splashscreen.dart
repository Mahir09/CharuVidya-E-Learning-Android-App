import 'dart:async';
import 'package:charuvidya/Screens/HomeScreen/HomeScreen.dart';
import 'package:charuvidya/Screens/introscreen.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = new UserSecureStorage(key: "id_token");
  String jwt_token;

  @override
  void initState()  {
    init();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
            child: (jwt_token != null) ? HomeScreen() : IntroScreen(), type: PageTransitionType.rightToLeftWithFade),
      ),
    );
    super.initState();
  }

  Future init() async {
    jwt_token = await storage.getIdToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20 , right: 20),
                child: SizedBox(
                  height: 300,
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
