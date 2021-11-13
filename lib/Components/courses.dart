import 'dart:convert';

import 'package:charuvidya/Components/CustomGridView.dart';
import 'package:charuvidya/Screens/DetailSection/CourseDetail.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class Courses extends StatefulWidget {
final index;
  Courses({Key key, this.index}) : super(key: key);

  @override
  _CoursesState createState() => _CoursesState(index: index);
}

class _CoursesState extends State<Courses> {
  _CoursesState({this.index});

  int index;
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
    print("JWT >> $jwt");
    final response = await http.get(
        "http://117.239.83.200:9000/api/courses/category/$index",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $IDtoken',
        });
    print('JWT Token : ${IDtoken}');
    // print(json.decode(response.body));
    setState(() {
      data = json.decode(response.body);
    });

    print(data);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.coursesData);
    return LayoutBuilder(
      builder: (context, dimens) {
        if (dimens.maxWidth <= 576) {
          return CustomGridView(
            columnRatio: 6,
            jsondata: data,
          );
        } else if (dimens.maxWidth > 576 && dimens.maxWidth <= 1024) {
          return CustomGridView(
            columnRatio: 4,
            jsondata: data,
          );
        } else if (dimens.maxWidth > 1024 && dimens.maxWidth <= 1366) {
          return CustomGridView(
            columnRatio: 3,
            jsondata: data,
          );
        } else {
          return CustomGridView(
            columnRatio: 2,
            jsondata: data,
          );
        }
      },
    );
  }
}
//
// class CustomGridView extends StatelessWidget {
//   CustomGridView({@required this.columnRatio, @required this.jsondata})
//       : super();
//
//   final int columnRatio;
//   var jsondata;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Center(child: Text('Courses')),
//       ),
//       body: (jsondata != null) ? StaggeredGridView.countBuilder(
//         primary: false,
//         crossAxisCount: 12,
//         itemBuilder: (context, index) => GestureDetector(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 fullscreenDialog: false,
//                 // builder: (context) => CourseDetail('Java Programming Language', 'Minal', '4.5', '2,000', '499', 'assets/images/java.jpeg'),
//                 builder: (context) => CourseDetail(
//                   courseData: jsondata[index],
//
//                 ),
//               ),
//             );
//             // print("INDEXxxxxxxxxxxxx >>> ${jsondata[index]}");
//           },
//           child: Container(
//             // decoration: BoxDecoration(
//             //     color: _myColorList[random.nextInt(_myColorList.length)],
//             //     borderRadius: BorderRadius.circular(4),
//             //     boxShadow: const [
//             //       BoxShadow(
//             //           color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)
//             //     ]),
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: NetworkImage('${jsondata[index]['logo']}'),
//               ),
//             ),
//             height: 200,
//             margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//             child: Column(children: [
//               Expanded(
//                 child: Container(),
//               ),
//               Container(
//                 color: Colors.white,
//                 child: ListTile(
//                   // leading: FlutterLogo(),
//                   title: Text(
//                     jsondata[index]['courseTitle'].length > 20
//                         ? jsondata[index]['courseTitle'].substring(0, 20) +
//                             '...'
//                         : jsondata[index]['courseTitle'],
//                   ),
//                   // title: Text(jsondata[index]['courseTitle']),
//                   subtitle: Text(
//                       "${jsondata[index]['user']['firstName']} ${jsondata[index]['user']['lastName']}"),
//                 ),
//               )
//             ]),
//           ),
//         ),
//         staggeredTileBuilder: (index) => StaggeredTile.fit(columnRatio),
//         itemCount: jsondata == null ? 0 : jsondata.length,
//       ) : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
