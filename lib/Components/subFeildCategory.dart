import 'dart:convert';
import 'dart:math';

import 'package:charuvidya/Components/courses.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubFieldCategory extends StatefulWidget {
  final index;
  const SubFieldCategory({Key key, this.index}) : super(key: key);

  @override
  _SubFieldCategoryState createState() => _SubFieldCategoryState(index: index);
}

class _SubFieldCategoryState extends State<SubFieldCategory> {
  _SubFieldCategoryState({this.index});

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
        "http://117.239.83.200:9000/api/course-category/sub-categories/$index",
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Sub Fields')),
      ),
      body: (data != null) ? ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title:
                      Text("${data[index]['courseCategoryTitle'].toString()}",textAlign: TextAlign.center,),
                ),
                Text(
                  'Count : ${Random().nextInt(20)}',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      textColor: const Color(0xFF6200EE),
                      onPressed: () {
                        print(index);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: false,
                            builder: (context) => Courses(
                              index: data[index]['id'],
                            ),
                          ),
                        );
                      },
                      child: const Text('View'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: data == null ? 0 : data.length,
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
