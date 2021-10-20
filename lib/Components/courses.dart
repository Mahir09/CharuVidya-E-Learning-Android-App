import 'package:charuvidya/Screens/DetailSection/CourseDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Courses extends StatefulWidget {
  final coursesData;

  Courses({Key key, this.coursesData}) : super(key: key);

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    print(widget.coursesData);
    return LayoutBuilder(
      builder: (context, dimens) {
        if (dimens.maxWidth <= 576) {
          return CustomGridView(
            columnRatio: 6,
            jsondata: widget.coursesData,
          );
        } else if (dimens.maxWidth > 576 && dimens.maxWidth <= 1024) {
          return CustomGridView(
            columnRatio: 4,
            jsondata: widget.coursesData,
          );
        } else if (dimens.maxWidth > 1024 && dimens.maxWidth <= 1366) {
          return CustomGridView(
            columnRatio: 3,
            jsondata: widget.coursesData,
          );
        } else {
          return CustomGridView(
            columnRatio: 2,
            jsondata: widget.coursesData,
          );
        }
      },
    );
  }
}

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
        title: Center(child: Text('Home')),
      ),
      body: StaggeredGridView.countBuilder(
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
      ),
    );
  }
}
