import 'dart:convert';

import 'package:charuvidya/Classes/user.dart';
import 'package:charuvidya/Components/alertBox.dart';
import 'package:charuvidya/Components/original_button.dart';
import 'package:charuvidya/Screens/HomeScreen/HomeScreen.dart';
import 'package:charuvidya/Screens/SignIn/SignUp.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
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
                // Text('Would you like to approve of this message?'),
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
        print(
            "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa   >>>>>>   ${account_data["authorities"][0]}");
        return true;
      } else {
        return false;
      }
    }
    // print(data["id_token"]);
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
        // print(account_data["authorities"][0]);
        if (account_data["authorities"][0] == "ROLE_FACULTY") {
          _showMyDialog("Faculty Role Alert",
              "You are login as faculty in mobile app, please use web version.");
          // return true;
        } else {
          await _storage.write(key: "id_token", value: data["id_token"]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      }
      // FacultyRoleAlert(data) != null ? print("Success") : print("Unsuccess");
      // print(data["id_token"]);

    } else if (data["title"] == "Unauthorized") {
      _showMyDialog(
        data["title"],
        "Password is incorrect",
      );
    } else if (data["title"] == "Incorrect login") {
      _showMyDialog(data["title"], "User dose not exists");
    } else {
      _showMyDialog("Something went wrong", data["title"]);
      // print(res.body);
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
                            height: 250,
                            semanticsLabel: 'Acme Logo'),
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
                        // if (_formKey.currentState.validate()) {
                        //   if (widget.authType == AuthType.login) {
                        //     // await authBase.loginWithEmailAndPassword(_email, _password);
                        //     Navigator.of(context).pushReplacementNamed('home');
                        //   } else {
                        //     // await authBase.registerWithEmailAndPassword(_email, _password);
                        //     Navigator.of(context).pushReplacementNamed('home');
                        //   }
                        // }
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Padding(
  //       padding: EdgeInsets.all(10),
  //       child: ListView(
  //         children: <Widget>[
  //           Container(
  //             alignment: Alignment.center,
  //             padding: EdgeInsets.all(10),
  //             child: Text(
  //               'CharuVidhya',
  //               style: TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 30),
  //             ),
  //           ),
  //           Container(
  //             alignment: Alignment.center,
  //             padding: EdgeInsets.all(10),
  //             child: Text(
  //               'Sign in',
  //               style: TextStyle(fontSize: 20),
  //             ),
  //           ),
  //           Form(
  //             key: _formKey,
  //             child: Column(
  //               children: <Widget>[
  //                 Padding(
  //                   padding: EdgeInsets.all(10),
  //                   child: TextFormField(
  //                     controller: TextEditingController(text: user.email),
  //                     onChanged: (val) {
  //                       user.email = val;
  //                     },
  //                     validator: (value) {
  //                       if (value.isEmpty) {
  //                         return 'Email is Empty';
  //                       }
  //                       return null;
  //                     },
  //                     keyboardType: TextInputType.emailAddress,
  //                     decoration: InputDecoration(
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide: new BorderSide(
  //                           color: Colors.black,
  //                           width: 1,
  //                           style: BorderStyle.solid,
  //                         ),
  //                       ),
  //                       labelText: 'User Name',
  //                       icon: Icon(
  //                         Icons.email,
  //                         color: Colors.black,
  //                       ),
  //                       fillColor: Colors.white,
  //                       labelStyle: TextStyle(
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.all(10),
  //                   child: TextFormField(
  //                     obscureText: true,
  //                     controller: TextEditingController(text: user.password),
  //                     onChanged: (val) {
  //                       user.password = val;
  //                     },
  //                     validator: (value) {
  //                       if (value.isEmpty) {
  //                         return 'Password is Empty';
  //                       }
  //                       return null;
  //                     },
  //                     decoration: InputDecoration(
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide: new BorderSide(
  //                           color: Colors.black,
  //                           width: 1,
  //                           style: BorderStyle.solid,
  //                         ),
  //                       ),
  //                       labelText: 'Password',
  //                       icon: Icon(
  //                         Icons.lock,
  //                         color: Colors.black,
  //                       ),
  //                       fillColor: Colors.white,
  //                       labelStyle: TextStyle(
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 15),
  //           Container(
  //             height: 50,
  //             padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //             child: RaisedButton.icon(
  //               textColor: Colors.white,
  //               color: Colors.black,
  //               label: Text(
  //                 'Sign in with Email',
  //                 style: TextStyle(fontSize: 18.0),
  //               ),
  //               icon: Icon(
  //                 EvaIcons.email,
  //                 size: 18.0,
  //               ),
  //               onPressed: () {
  //                 if (_formKey.currentState.validate()) {
  //                   save();
  //                 }
  //               },
  //             ),
  //           ),
  //           Container(
  //             margin: EdgeInsets.symmetric(vertical: 10),
  //             child: Row(
  //               children: <Widget>[
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 Expanded(
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 10),
  //                     child: Divider(
  //                       thickness: 1,
  //                     ),
  //                   ),
  //                 ),
  //                 Text('or'),
  //                 Expanded(
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 10),
  //                     child: Divider(
  //                       thickness: 1,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             height: 50,
  //             padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //             child: RaisedButton.icon(
  //               textColor: Colors.white,
  //               color: Colors.black,
  //               label: Text(
  //                 'Sign in with Google',
  //                 style: TextStyle(fontSize: 18.0),
  //               ),
  //               icon: Icon(
  //                 EvaIcons.google,
  //                 size: 18.0,
  //               ),
  //               onPressed: () {},
  //             ),
  //           ),
  //           Container(
  //             child: Row(
  //               children: <Widget>[
  //                 Text("Don't have an account?"),
  //                 FlatButton(
  //                   textColor: Colors.black,
  //                   child: Text(
  //                     'Sign up',
  //                     style: TextStyle(fontSize: 15),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(context).push(
  //                       MaterialPageRoute(
  //                         fullscreenDialog: false,
  //                         builder: (context) => SignUp(),
  //                       ),
  //                     );
  //                     // Navigator.pushReplacement(
  //                     //   context,
  //                     //   PageTransition(
  //                     //       child: SignUp(),
  //                     //       type: PageTransitionType.bottomToTop),
  //                     // );
  //                   },
  //                 ),
  //               ],
  //               mainAxisAlignment: MainAxisAlignment.center,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //   // body: Container(
  //   //   child: Center(
  //   //     child: Column(
  //   //       crossAxisAlignment: CrossAxisAlignment.center,
  //   //       mainAxisAlignment: MainAxisAlignment.center,
  //   //       children: [
  //   //         Padding(
  //   //           padding: const EdgeInsets.only(bottom: 10.0),
  //   //           child: Text(
  //   //             'Sign In',
  //   //             style: TextStyle(
  //   //               color: Colors.black,
  //   //               fontSize: 20,
  //   //               fontWeight: FontWeight.bold,
  //   //             ),
  //   //           ),
  //   //         ),
  //   //         Form(
  //   //           // key: _formStateKey,
  //   //           autovalidate: true,
  //   //           child: Column(
  //   //             children: <Widget>[
  //   //               Padding(
  //   //                 padding: EdgeInsets.all(10),
  //   //                 child: TextFormField(
  //   //                   // validator: validateEmail,
  //   //                   // onSaved: (value) {
  //   //                   //   _emailId = value;
  //   //                   // },
  //   //                   keyboardType: TextInputType.emailAddress,
  //   //                   // controller: _emailIdController,
  //   //                   decoration: InputDecoration(
  //   //                     focusedBorder: OutlineInputBorder(
  //   //                         borderSide: new BorderSide(
  //   //                             color: Colors.blue,
  //   //                             width: 2,
  //   //                             style: BorderStyle.solid)),
  //   //                     labelText: 'Email Id',
  //   //                     icon: Icon(
  //   //                       Icons.email,
  //   //                       color: Colors.blue,
  //   //                     ),
  //   //                     fillColor: Colors.white,
  //   //                     labelStyle: TextStyle(
  //   //                       color: Colors.blue,
  //   //                     ),
  //   //                   ),
  //   //                 ),
  //   //               ),
  //   //               Padding(
  //   //                 padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //   //                 child: TextFormField(
  //   //                   // validator: validatePassword,
  //   //                   // onSaved: (value) {
  //   //                   //   _password = value;
  //   //                   // },
  //   //                   obscureText: true,
  //   //                   // controller: _passwordController,
  //   //                   decoration: InputDecoration(
  //   //                     focusedBorder: OutlineInputBorder(
  //   //                         borderSide: new BorderSide(
  //   //                             color: Colors.blue,
  //   //                             width: 2,
  //   //                             style: BorderStyle.solid)),
  //   //                     labelText: 'Password',
  //   //                     icon: Icon(
  //   //                       Icons.email,
  //   //                       color: Colors.blue,
  //   //                     ),
  //   //                     fillColor: Colors.white,
  //   //                     labelStyle: TextStyle(
  //   //                       color: Colors.blue,
  //   //                     ),
  //   //                   ),
  //   //                 ),
  //   //               ),
  //   //             ],
  //   //           ),
  //   //         ),
  //   //         Padding(
  //   //           padding: const EdgeInsets.only(bottom: 15.0),
  //   //           child: FlatButton.icon(
  //   //               color: Colors.white,
  //   //               onPressed: () {
  //   //                 print("Google sign in...");
  //   //               },
  //   //               icon: Icon(EvaIcons.google),
  //   //               label: Text('Sign in with google')),
  //   //         ),
  //   //         Padding(
  //   //           padding: const EdgeInsets.only(bottom: 15.0),
  //   //           child: FlatButton.icon(
  //   //               color: Colors.white,
  //   //               onPressed: () {
  //   //                 print("Email sign in...");
  //   //               },
  //   //               icon: Icon(EvaIcons.email),
  //   //               label: Text('Sign in with Email')),
  //   //         ),
  //   //         Padding(
  //   //           padding: const EdgeInsets.only(left: 100.0),
  //   //           child: Row(
  //   //             children: [
  //   //               Text(
  //   //                 'New Here?',
  //   //                 style: TextStyle(color: Colors.black),
  //   //               ),
  //   //               MaterialButton(
  //   //                 onPressed: () {
  //   //                   Navigator.pushReplacement(
  //   //                     context,
  //   //                     PageTransition(
  //   //                         child: SignUp(),
  //   //                         type: PageTransitionType.bottomToTop),
  //   //                   );
  //   //                 },
  //   //                 child: Text('Create an account',style: TextStyle(color: Colors.black),),
  //   //               ),
  //   //             ],
  //   //           ),
  //   //         )
  //   //       ],
  //   //     ),
  //   //   ),
  //   //   // decoration: BoxDecoration(
  //   //   //   image: DecorationImage(
  //   //   //     image: AssetImage('images/landingpage-bg.png'),
  //   //   //     fit: BoxFit.fitHeight,
  //   //   //     // colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
  //   //   //   ),
  //   //   // ),
  //   // ),
  //   // );
  // }
}
