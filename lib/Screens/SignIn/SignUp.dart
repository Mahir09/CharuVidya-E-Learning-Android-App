import 'dart:convert';

import 'package:charuvidya/Classes/user.dart';
import 'package:charuvidya/Components/original_button.dart';
import 'package:charuvidya/Screens/HomeScreen/HomeScreen.dart';
import 'package:charuvidya/Screens/SignIn/Signin.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  UserRegister user = UserRegister("", "", ['ROLE_STUDENT'], "en", "");
  String url = "http://117.239.83.200:9000/api/register";
  var data;

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

  Future save() async {
    // print(json.encode({
    //   'authorities': user.authorities,
    //   'email' : user.email,
    //   'langKey': user.lanKey,
    //   'login': user.login,
    //   'password': user.password
    // }),);
    var res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'authorities': user.authorities,
        'email': user.email,
        'langKey': user.lanKey,
        'login': user.login,
        'password': user.password
      }),
    );
    print(res.body.length);
    if (res.body.isNotEmpty) {
      data = json.decode(res.body);
    }
    if (res.body == "") {
      _showMyDialog("Successful", 'Confirmation email sent to your email id.');
      _formKey.currentState.reset();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(),
      //   ),
      // );
    } else {
      _showMyDialog("Something went wrong", data["title"]);
      print(res.body);
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
                        'Welcome!',
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
                        child: SvgPicture.asset('assets/register.svg',
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
                      controller: TextEditingController(text: user.login),
                      decoration: InputDecoration(
                        labelText: 'Enter your username',
                        hintText: 'ex: Username',
                      ),
                      onChanged: (value) {
                        user.login = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid username'
                          : null,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: TextEditingController(text: user.email),
                      decoration: InputDecoration(
                        labelText: 'Enter your email',
                        hintText: 'ex: test@gmail.com',
                      ),
                      onChanged: (value) {
                        user.email = value;
                      },
                      validator: (value) =>
                          value.isEmpty ? 'You must enter a valid email' : null,
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
                      validator: (value) => value.length <= 6
                          ? 'Your password must be larger than 6 characters'
                          : null,
                    ),
                    SizedBox(height: 20),
                    OriginalButton(
                      text: 'Register',
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
//                  print(_email);
//                  print(_password);
//                         }
                      },
                    ),
                    SizedBox(height: 6),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: false,
                            builder: (context) => SignIn(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account?',
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
  //       backgroundColor: Colors.white,
  //       body: Padding(
  //           padding: EdgeInsets.all(10),
  //           child: ListView(
  //             children: <Widget>[
  //               Container(
  //                   alignment: Alignment.center,
  //                   padding: EdgeInsets.all(10),
  //                   child: Text(
  //                     'CharuVidya',
  //                     style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 30),
  //                   )),
  //               Container(
  //                   alignment: Alignment.center,
  //                   padding: EdgeInsets.all(10),
  //                   child: Text(
  //                     'Sign up',
  //                     style: TextStyle(fontSize: 20),
  //                   )),
  //               Form(
  //                 key: _formKey,
  //                 child: Column(
  //                   children: <Widget>[
  //                     Padding(
  //                       padding: EdgeInsets.all(10),
  //                       child: TextFormField(
  //                         controller: TextEditingController(text: user.login),
  //                         onChanged: (val) {
  //                           user.login = val;
  //                         },
  //                         validator: (value) {
  //                           if (value.isEmpty) {
  //                             return 'User name is empty';
  //                           }
  //                           return null;
  //                         },
  //                         keyboardType: TextInputType.text,
  //                         decoration: InputDecoration(
  //                           focusedBorder: OutlineInputBorder(
  //                               borderSide: new BorderSide(
  //                                   color: Colors.black,
  //                                   width: 1,
  //                                   style: BorderStyle.solid)),
  //                           labelText: 'User Name',
  //                           icon: Icon(
  //                             Icons.textsms,
  //                             color: Colors.black,
  //                           ),
  //                           fillColor: Colors.white,
  //                           labelStyle: TextStyle(
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.all(10),
  //                       child: TextFormField(
  //                         controller: TextEditingController(text: user.email),
  //                         onChanged: (val) {
  //                           user.email = val;
  //                         },
  //                         validator: (value) {
  //                           if (value.isEmpty) {
  //                             return 'Email id is empty';
  //                           }
  //                           return null;
  //                         },
  //                         keyboardType: TextInputType.emailAddress,
  //                         decoration: InputDecoration(
  //                           focusedBorder: OutlineInputBorder(
  //                               borderSide: new BorderSide(
  //                                   color: Colors.black,
  //                                   width: 1,
  //                                   style: BorderStyle.solid)),
  //                           labelText: 'Email Id',
  //                           icon: Icon(
  //                             Icons.email,
  //                             color: Colors.black,
  //                           ),
  //                           fillColor: Colors.white,
  //                           labelStyle: TextStyle(
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
  //                       child: TextFormField(
  //                         controller:
  //                             TextEditingController(text: user.password),
  //                         onChanged: (val) {
  //                           user.password = val;
  //                         },
  //                         validator: (value) {
  //                           if (value.isEmpty) {
  //                             return 'Password is empty';
  //                           }
  //                           return null;
  //                         },
  //                         obscureText: true,
  //                         decoration: InputDecoration(
  //                           focusedBorder: OutlineInputBorder(
  //                               borderSide: new BorderSide(
  //                                   color: Colors.black,
  //                                   width: 1,
  //                                   style: BorderStyle.solid)),
  //                           labelText: 'Password',
  //                           icon: Icon(
  //                             Icons.lock,
  //                             color: Colors.black,
  //                           ),
  //                           fillColor: Colors.white,
  //                           labelStyle: TextStyle(
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     // Padding(
  //                     //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //                     //   child: TextFormField(
  //                     //     obscureText: true,
  //                     //     decoration: InputDecoration(
  //                     //       focusedBorder: OutlineInputBorder(
  //                     //           borderSide: new BorderSide(
  //                     //               color: Colors.black,
  //                     //               width: 1,
  //                     //               style: BorderStyle.solid)),
  //                     //       labelText: ' Confirm Password',
  //                     //       icon: Icon(
  //                     //         Icons.lock,
  //                     //         color: Colors.black,
  //                     //       ),
  //                     //       fillColor: Colors.white,
  //                     //       labelStyle: TextStyle(
  //                     //         color: Colors.black,
  //                     //       ),
  //                     //     ),
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 15),
  //               Container(
  //                 height: 50,
  //                 padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //                 child: RaisedButton.icon(
  //                   textColor: Colors.white,
  //                   color: Colors.black,
  //                   label: Text(
  //                     'Register',
  //                     style: TextStyle(fontSize: 18.0),
  //                   ),
  //                   icon: Icon(
  //                     EvaIcons.doneAll,
  //                     size: 18.0,
  //                   ),
  //                   onPressed: () {
  //                     if (_formKey.currentState.validate()) {
  //                       save();
  //                     }
  //                   },
  //                 ),
  //               ),
  //               Container(
  //                 margin: EdgeInsets.symmetric(vertical: 10),
  //                 child: Row(
  //                   children: <Widget>[
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                     Expanded(
  //                       child: Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 10),
  //                         child: Divider(
  //                           thickness: 1,
  //                         ),
  //                       ),
  //                     ),
  //                     Text('or'),
  //                     Expanded(
  //                       child: Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 10),
  //                         child: Divider(
  //                           thickness: 1,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 20,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                   child: Row(
  //                 children: <Widget>[
  //                   Text('Already have an account?'),
  //                   FlatButton(
  //                     textColor: Colors.black,
  //                     child: Text(
  //                       'Sign in',
  //                       style: TextStyle(fontSize: 15),
  //                     ),
  //                     onPressed: () {
  //                       Navigator.pushReplacement(
  //                         context,
  //                         PageTransition(
  //                             child: SignIn(),
  //                             type: PageTransitionType.bottomToTop),
  //                       );
  //                     },
  //                   )
  //                 ],
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //               )),
  //             ],
  //           )));
  // }
}
