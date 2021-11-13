import 'dart:convert';
import 'package:charuvidya/Components/CustomGridView.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyCourse extends StatefulWidget {
  @override
  _MyCourseState createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> {
  String url = "http://117.239.83.200:9000/api/courses/enrolled";
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
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $IDtoken',
    });
    print('Token : ${IDtoken}');
    setState(() {
      data = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
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