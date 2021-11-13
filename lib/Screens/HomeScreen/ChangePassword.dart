import 'dart:convert';

import 'package:charuvidya/Classes/user.dart';
import 'package:charuvidya/Components/original_button.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  UserChangePassword userChangePassword = UserChangePassword("", "", "");

  String url = "";
  String IDtoken = "";
  var data;

  final storageIdToken = new UserSecureStorage(key: "id_token");

  // final queryParameters = {
  //   'currentPassword': '',
  //   'newPassword': '',
  // };

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

  @override
  void initState() {
    super.initState();
    // init();
  }

  // Future init() async {
  //   final uri = Uri.https('http://117.239.83.200:9000',
  //       '/api/account/change-password', queryParameters);
  //   final jwt = await storageIdToken.getIdToken();
  //   IDtoken = jwt;
  //   final response = await http.get(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $IDtoken',
  //     },
  //   );
  //   print("REEEEESSSSSS > ${response.body}");
  //   // if (response.body.isNotEmpty) {
  //   //   setState(() {
  //   //     data = json.decode(response.body);
  //   //   });
  //   // }
  //   // print(data);
  //   // if (data["imageUrl"] != "") {
  //   //   setState(() {
  //   //     imageUrl = true;
  //   //   });
  //   // }
  // }

  Future save() async {
    if (userChangePassword.newPassword != userChangePassword.copyNewPassword) {
      _showMyDialog(
          "Failed!", "New password and confirm password must be same.");
    }
    else {
      var res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'currentPassword': userChangePassword.currentPassword,
          'newPassword': userChangePassword.newPassword,
        }),
      );
      data = json.decode(res.body);
      // if (data["id_token"] != null) {
      //   final account_res = await http.get(
      //     account_url,
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Accept': 'application/json',
      //       'Authorization': 'Bearer ${data["id_token"]}',
      //     },
      //   );
      //   var account_data;
      //   if (account_res.body.isNotEmpty) {
      //     account_data = json.decode(account_res.body);
      //     if (account_data["authorities"][0] == "ROLE_FACULTY") {
      //       _showMyDialog("Faculty Role Alert",
      //           "You are login as faculty in mobile app, please use web version.");
      //     } else {
      //       await _storage.write(key: "id_token", value: data["id_token"]);
      //       Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomeScreen()),
      //             (Route<dynamic> route) => false,
      //       );
      //     }
      //   }
      // } else if (data["title"] == "Unauthorized") {
      //   _showMyDialog(
      //     data["title"],
      //     "Password is incorrect",
      //   );
      // } else if (data["title"] == "Incorrect login") {
      //   _showMyDialog(data["title"], "User dose not exists");
      // } else {
      //   _showMyDialog("Something went wrong", data["title"]);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Change Password')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Password for [USER]",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: TextEditingController(
                          text: userChangePassword.currentPassword),
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        hintText: 'ex: Pass@123',
                      ),
                      // obscureText: true,
                      onChanged: (value) {
                        userChangePassword.currentPassword = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid password'
                          : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: TextEditingController(
                          text: userChangePassword.newPassword),
                      decoration: InputDecoration(
                        labelText: 'Enter New Password',
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        userChangePassword.newPassword = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid password'
                          : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: TextEditingController(
                          text: userChangePassword.copyNewPassword),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      // obscureText: true,
                      onChanged: (value) {
                        userChangePassword.copyNewPassword = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a same password'
                          : null,
                    ),
                    SizedBox(height: 20),
                    OriginalButton(
                      text: 'Confirm',
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          save();
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    OriginalButton(
                        text: 'Cancel',
                        color: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    SizedBox(height: 6),
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
