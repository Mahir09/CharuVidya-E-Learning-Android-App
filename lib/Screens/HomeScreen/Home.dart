import 'dart:convert';
import 'dart:math';

import 'package:charuvidya/Components/courses.dart';
import 'package:charuvidya/Screens/DetailSection/CourseDetail.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url = "http://117.239.83.200:9000/api/courses/top-10";
  String IDtoken = "";
  var data;

  final storage = new UserSecureStorage(key: "id_token");
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final jwt = await storage.getIdToken();
    IDtoken = jwt;
    // print("JWT >> $jwt");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    print('JWT Token : ${IDtoken}');
    // print(json.decode(response.body));
    setState(() {
      data = json.decode(response.body);
    });

  }

  // Future save() async {
  //   var res = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $IDtoken',
  //     },
  //   );
  //   print("ID >>> $IDtoken");
  //   print('aaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //   print(res.body);
  //   print('aaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //   var data = json.decode(res.body);
  //   print(data);
  //   // if (data["id_token"] != null) {
  //   //   // print(data["id_token"]);
  //   //   await _storage.write(key: "id_token", value: data["id_token"]);
  //   //   Navigator.push(
  //   //     context,
  //   //     MaterialPageRoute(
  //   //       builder: (context) => HomeScreen(),
  //   //     ),
  //   //   );
  //   // } else if (data["title"] == "Unauthorized") {
  //   //   _showMyDialog(
  //   //     data["title"],
  //   //     "Password is incorrect",
  //   //   );
  //   // } else if (data["title"] == "Incorrect login") {
  //   //   _showMyDialog(data["title"], "User dose not exists");
  //   // } else {
  //   //   _showMyDialog("Something went wrong", data["title"]);
  //   //   print(res.body);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    // print(data);
    return Courses(coursesData: data);
    // return LayoutBuilder(
    //   builder: (context, dimens) {
    //     if (dimens.maxWidth <= 576) {
    //       return CustomGridView(
    //         columnRatio: 6,
    //         jsondata: data,
    //       );
    //     } else if (dimens.maxWidth > 576 && dimens.maxWidth <= 1024) {
    //       return CustomGridView(
    //         columnRatio: 4,
    //         jsondata: data,
    //       );
    //     } else if (dimens.maxWidth > 1024 && dimens.maxWidth <= 1366) {
    //       return CustomGridView(
    //         columnRatio: 3,
    //         jsondata: data,
    //       );
    //     } else {
    //       return CustomGridView(
    //         columnRatio: 2,
    //         jsondata: data,
    //       );
    //     }
    //   },
    // );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Home'),
    //   ),
    //
    //   body: new ListView.builder(
    //     itemCount: data == null ? 0 : data.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return new Card(
    //         child: new Text(data[index]["courseTitle"]),
    //       );
    //     },
    //   ),
    // );
  }
}

// ignore: must_be_immutable
// class CustomGridView extends StatelessWidget {
//   CustomGridView({@required this.columnRatio, @required this.jsondata})
//       : super();
//
//   final int columnRatio;
//   List jsondata;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Center(child: Text('Home')),
//       ),
//       body: StaggeredGridView.countBuilder(
//         primary: false,
//         crossAxisCount: 12,
//         itemBuilder: (context, index) => Container(
//           // decoration: BoxDecoration(
//           //     color: _myColorList[random.nextInt(_myColorList.length)],
//           //     borderRadius: BorderRadius.circular(4),
//           //     boxShadow: const [
//           //       BoxShadow(
//           //           color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)
//           //     ]),
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               fit: BoxFit.contain,
//               image: NetworkImage('${jsondata[index]['logo']}'),
//             ),
//           ),
//           height: 200,
//           margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//           child: Column(children: [
//             Expanded(
//               child: Container(),
//             ),
//             Container(
//               color: Colors.white,
//               child: ListTile(
//                 // leading: FlutterLogo(),
//                 title: Text(
//                   jsondata[index]['courseTitle'].length > 20
//                       ? jsondata[index]['courseTitle'].substring(0, 20) + '...'
//                       : jsondata[index]['courseTitle'],
//                 ),
//                 // title: Text(jsondata[index]['courseTitle']),
//                 subtitle: Text(
//                     "${jsondata[index]['user']['firstName']} ${jsondata[index]['user']['lastName']}"),
//               ),
//             )
//           ]),
//         ),
//         staggeredTileBuilder: (index) => StaggeredTile.fit(columnRatio),
//         itemCount: jsondata == null ? 0 : jsondata.length,
//       ),
//     );
//   }
// }

// body: SingleChildScrollView(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Padding(
// padding: const EdgeInsets.only(left: 8.0, top: 8),
// child: Text(
// 'Featured',
// style: TextStyle(
// color: Colors.black,
// fontSize: 22,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// SizedBox(
// height: 270,
// width: 400,
// child: ListView(
// scrollDirection: Axis.horizontal,
// children: [
// GestureDetector(
// onTap: () {
// Navigator.of(context).push(
// MaterialPageRoute(
// fullscreenDialog: false,
// builder: (context) => CourseDetail(
// 'Computer Concepts & Programming with C',
// 'Priyanka',
// '4.5',
// '2,000',
// '499',
// 'assets/images/c.jpeg'),
// ),
// );
// },
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/c.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Computer Concepts & Programming with C',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Priyanka',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// ),
// GestureDetector(
// onTap: () {
// Navigator.of(context).push(
// MaterialPageRoute(
// fullscreenDialog: false,
// builder: (context) => CourseDetail(
// 'Java Programming Language',
// 'Minal',
// '4.5',
// '2,000',
// '499',
// 'assets/images/java.jpeg'),
// ),
// );
// // Navigator.pushReplacement(
// //   context,
// //   PageTransition(
// //       child: CourseDetail('Java Programming Language', 'Minal', '4.5', '2,000', '499', 'assets/images/java.jpeg'),
// //       type: PageTransitionType.leftToRight),
// // );
// },
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/java.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Java Programming Language',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Minal',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/c.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Computer Concepts & Programming with C',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Priyanka',
// style: TextStyle(
// color: Colors.grey.shade700, fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/java.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Java Programming Language',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Minal',
// style: TextStyle(
// color: Colors.grey.shade700, fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 8.0),
// child: Text(
// 'New',
// style: TextStyle(
// color: Colors.black,
// fontSize: 22,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// SizedBox(
// height: 270,
// width: 500,
// child: ListView(
// scrollDirection: Axis.horizontal,
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/java.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Java Programming Language',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Minal',
// style: TextStyle(
// color: Colors.grey.shade700, fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/c.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Computer Concepts & Programming with C',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Priyanka',
// style: TextStyle(
// color: Colors.grey.shade700, fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/java.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Java Programming Language',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Minal',
// style: TextStyle(
// color: Colors.grey.shade700, fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: 130,
// width: 130,
// decoration: BoxDecoration(
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage('assets/images/c.jpeg'),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Computer Concepts & Programming with C',
// style: TextStyle(
// color: Colors.black, fontSize: 14),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Container(
// constraints: BoxConstraints(maxWidth: 150),
// child: Text(
// 'Priyanka',
// style: TextStyle(
// color: Colors.grey.shade700, fontSize: 12),
// ),
// ),
// ),
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(top: 1.0),
// child: Text(
// '4.5',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 4.0),
// child: Text(
// '(2,000)',
// style: TextStyle(
// color: Colors.grey.shade700,
// fontSize: 16),
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(top: 4.0),
// child: Row(
// children: [
// Icon(
// FontAwesomeIcons.rupeeSign,
// color: Colors.black,
// size: 20,
// ),
// Text(
// '499',
// style: TextStyle(
// color: Colors.black, fontSize: 20),
// ),
// ],
// ),
// )
// ],
// ),
// ),
// ),
// ],
// ),
// )
// ],
// ),
