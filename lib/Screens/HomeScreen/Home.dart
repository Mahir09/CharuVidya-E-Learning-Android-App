import 'dart:convert';
import 'package:charuvidya/Components/fieldCategory.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url =
      "http://117.239.83.200:9000/api/course-category/parent-categories";
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
    print('JWT Token : ${IDtoken}');
    setState(() {
      data = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(data);
    return FieldCategory(
      jsonData: data,
    );
  }
}

