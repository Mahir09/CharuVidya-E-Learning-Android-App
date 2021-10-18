import 'package:charuvidya/Screens/splashscreen.dart';
import 'package:charuvidya/Temp/home_screen.dart';
import 'package:charuvidya/Temp/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CharuVidya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen()
      //   home: HomeScreen(),
    );
  }
}
