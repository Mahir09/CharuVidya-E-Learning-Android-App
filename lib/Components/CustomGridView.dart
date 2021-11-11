import 'package:charuvidya/Screens/DetailSection/CourseDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomGridView extends StatelessWidget {
  CustomGridView({@required this.columnRatio, @required this.jsondata})
      : super();

  final int columnRatio;
  var jsondata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Courses')),
      ),
      body: (jsondata != null) ? StaggeredGridView.countBuilder(
        primary: false,
        crossAxisCount: 12,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: false,
                // builder: (context) => CourseDetail('Java Programming Language', 'Minal', '4.5', '2,000', '499', 'assets/images/java.jpeg'),
                builder: (context) => CourseDetail(
                  courseData: jsondata[index],

                ),
              ),
            );
            // print("INDEXxxxxxxxxxxxx >>> ${jsondata[index]}");
          },
          child: Container(
            // decoration: BoxDecoration(
            //     color: _myColorList[random.nextInt(_myColorList.length)],
            //     borderRadius: BorderRadius.circular(4),
            //     boxShadow: const [
            //       BoxShadow(
            //           color: Colors.black26, offset: Offset(0, 2), blurRadius: 6)
            //     ]),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('${jsondata[index]['logo']}'),
              ),
            ),
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Column(children: [
              Expanded(
                child: Container(),
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  // leading: FlutterLogo(),
                  title: Text(
                    jsondata[index]['courseTitle'].length > 20
                        ? jsondata[index]['courseTitle'].substring(0, 20) +
                        '...'
                        : jsondata[index]['courseTitle'],
                  ),
                  // title: Text(jsondata[index]['courseTitle']),
                  subtitle: Text(
                      "${jsondata[index]['user']['firstName']} ${jsondata[index]['user']['lastName']}"),
                ),
              )
            ]),
          ),
        ),
        staggeredTileBuilder: (index) => StaggeredTile.fit(columnRatio),
        itemCount: jsondata == null ? 0 : jsondata.length,
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}