import 'dart:convert';
import 'package:charuvidya/Classes/user.dart';
import 'package:charuvidya/Components/original_button.dart';
import 'package:charuvidya/Screens/HomeScreen/HomeScreen.dart';
import 'package:charuvidya/Screens/SignIn/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthType { login, register }

class SignIn extends StatefulWidget {
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  UserLogin user = UserLogin("", "");
  String url = "http://117.239.83.200:9000/api/authenticate";
  String account_url = "http://117.239.83.200:9000/api/account";
  var data;
  final _storage = FlutterSecureStorage();

  Future<void> _showMyDialog(String title, String discription) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(discription),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> FacultyRoleAlert(var data) async {
    final account_res = await http.get(account_url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${data["id_token"]}',
    });
    var account_data;
    if (account_res.body == "") {
      account_data = json.decode(account_res.body);
      if (account_data["authorities"][0] == "ROLE_STUDENT") {
        print("aaaaaaaaaaaa   >>>>>>   ${account_data["authorities"][0]}");
        return true;
      } else {
        return false;
      }
    }
  }

  Future save() async {
    var res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': user.email,
        'password': user.password,
        'rememberMe': false
      }),
    );
    data = json.decode(res.body);
    if (data["id_token"] != null) {
      final account_res = await http.get(
        account_url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${data["id_token"]}',
        },
      );
      var account_data;
      if (account_res.body.isNotEmpty) {
        account_data = json.decode(account_res.body);
        if (account_data["authorities"][0] == "ROLE_FACULTY") {
          _showMyDialog("Faculty Role Alert",
              "You are login as faculty in mobile app, please use web version.");
        } else {
          await _storage.write(key: "id_token", value: data["id_token"]);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } else if (data["title"] == "Unauthorized") {
      _showMyDialog(
        data["title"],
        "Password is incorrect",
      );
    } else if (data["title"] == "Incorrect login") {
      _showMyDialog(data["title"], "User dose not exists");
    } else {
      _showMyDialog("Something went wrong", data["title"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 65),
                      Text(
                        'Hello!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Hero(
                        tag: 'logoAnimation',
                        child: SvgPicture.asset('assets/login.svg',
                            height: 250, semanticsLabel: 'Acme Logo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: TextEditingController(text: user.email),
                      decoration: InputDecoration(
                        labelText: 'Enter your username',
                        hintText: 'ex: Username',
                      ),
                      onChanged: (value) {
                        user.email = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid username'
                          : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: TextEditingController(text: user.password),
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        user.password = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid password'
                          : null,
                    ),
                    SizedBox(height: 20),
                    OriginalButton(
                      text: 'Login',
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          save();
                        }
                      },
                    ),
                    SizedBox(height: 6),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            fullscreenDialog: false,
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
