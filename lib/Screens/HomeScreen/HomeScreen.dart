import 'package:charuvidya/Screens/HomeScreen/Account.dart';
import 'package:charuvidya/Screens/HomeScreen/Home.dart';
import 'package:charuvidya/Screens/HomeScreen/MyCourse.dart';
import 'package:charuvidya/Screens/HomeScreen/Search.dart';
import 'package:charuvidya/Screens/HomeScreen/Wishlist.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = new PageController();
  int currentIndex = 0;

  void onTap(int page){
    setState(() {
      currentIndex = page;
    });
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index){
          setState(() {
            currentIndex = index;
          });
        },
        controller: pageController,
        children: [
          Home(),
          Search(),
          MyCourse(),
          // Wishlist(),
          Account(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        backgroundColor: Colors.grey.shade900,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        unselectedIconTheme: IconThemeData(color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.white),
        unselectedItemColor: Colors.white,
        iconSize: 20,
        selectedFontSize: 13,
        unselectedFontSize: 10,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              EvaIcons.home,
            ),
            title: Text(
              "Home",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              EvaIcons.search,
            ),
            title: Text(
              "Search",
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.my_library_books_outlined,
            ),
            title: Text(
              "My Course",
            ),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     EvaIcons.heart,
          //   ),
          //   title: Text(
          //     "Wishlist",
          //   ),
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
            ),
            title: Text(
              "Profile",
            ),
          ),
        ],
      ),
    );
  }
}
