import 'dart:convert';

import 'package:charuvidya/Screens/HomeScreen/ChangePassword.dart';
import 'package:charuvidya/Screens/landingpage.dart';
import 'package:charuvidya/Secure/Secure_id_token.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FlutterSecureStorage mainStorage = FlutterSecureStorage();

  String url = "http://117.239.83.200:9000/api/account";
  String IDtoken = "";
  bool imageUrl = false;
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
    // print("JWT >> $jwt");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $IDtoken',
      },
    );
    // print('Token : ${IDtoken}');
    // print(json.decode(response.body));
    if (response.body.isNotEmpty) {
      setState(() {
        data = json.decode(response.body);
      });
    }
    print(data);
    // print(data["imageUrl"]);
    if (data["imageUrl"] != "") {
      setState(() {
        imageUrl = true;
      });
    }
  }

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
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                mainStorage.delete(key: 'id_token');
                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       child: IntroScreen(),
                //       type: PageTransitionType.bottomToTop),
                // );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => IntroScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Account')),
        //backgroundColor: Colors.white,
      ),
      body: (data != null)
          ? Container(
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.person, color: Color(0xff3C8CE7)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Your Profile",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      backgroundImage: (imageUrl)
                          ? NetworkImage(data['imageUrl'])
                          : AssetImage("assets/images/default_profile_img.jpg"),
                      radius: 65,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Email address: ${data['email']}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Username : ${data['firstName']} ${data['lastName']}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.settings, color: Color(0xff3C8CE7)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            child: ChangePassword(),
                            type: PageTransitionType.leftToRight),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Color(0xff3C8CE7))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Color(0xff3C8CE7))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showMyDialog(
                          "Confirm", "Are You Sure You Want To Logout?");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sign Out",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.red)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       title: Center(child: Text('Account')),
  //     ),
  //     body: (data != null) ? SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(
  //             height: 200,
  //             width: 400,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 CircleAvatar(
  //                   radius: 70,
  //                   backgroundColor: Colors.black,
  //                   child: CircleAvatar(
  //                     backgroundImage: (imageUrl)
  //                         ? NetworkImage(data['imageUrl'])
  //                         : AssetImage("assets/images/default_profile_img.jpg"),
  //                     radius: 65,
  //                   ),
  //                 ),
  //                 // : CircleAvatar(
  //                 //     radius: 70,
  //                 //     backgroundColor: Colors.black,
  //                 //     child: CircleAvatar(
  //                 //       backgroundImage: AssetImage("assets/images/default_profile_img.jpg"),
  //                 //       radius: 65,
  //                 //     ),
  //                 //   ),
  //                 Text(
  //                   '${data['firstName']} ${data['lastName']}',
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 24,
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     // Icon(EvaIcons.google)
  //                     Text(
  //                       '${data['email']}',
  //                       style: TextStyle(
  //                         color: Colors.grey,
  //                         fontSize: 20,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 2.0),
  //             child: Text(
  //               'Settings',
  //               style: TextStyle(color: Colors.grey, fontSize: 14),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(2, 5, 2, 1),
  //             child: ListTile(
  //               trailing: Icon(
  //                 Icons.arrow_forward_ios,
  //                 color: Colors.black,
  //               ),
  //               title: Text(
  //                 'Option 1',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               tileColor: Colors.grey.shade300,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
  //             child: ListTile(
  //               trailing: Icon(
  //                 Icons.arrow_forward_ios,
  //                 color: Colors.black,
  //               ),
  //               title: Text(
  //                 'Option 2',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               tileColor: Colors.grey.shade300,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
  //             child: ListTile(
  //               trailing: Icon(
  //                 Icons.arrow_forward_ios,
  //                 color: Colors.black,
  //               ),
  //               title: Text(
  //                 'Option 3',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               tileColor: Colors.grey.shade300,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
  //             child: ListTile(
  //               trailing: Icon(
  //                 Icons.arrow_forward_ios,
  //                 color: Colors.black,
  //               ),
  //               title: Text(
  //                 'Option 4',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               tileColor: Colors.grey.shade300,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
  //             child: ListTile(
  //               trailing: Icon(
  //                 Icons.arrow_forward_ios,
  //                 color: Colors.black,
  //               ),
  //               title: Text(
  //                 'Option 5',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //               tileColor: Colors.grey.shade300,
  //             ),
  //           ),
  //           Center(
  //             child: MaterialButton(
  //               onPressed: () {
  //                 // mainStorage.delete(key: 'id_token');
  //                 // Navigator.pushReplacement(
  //                 //   context,
  //                 //   PageTransition(
  //                 //       child: IntroScreen(),
  //                 //       type: PageTransitionType.bottomToTop),
  //                 // );
  //                 _showMyDialog("Confirm", "Are You Sure You Want To Logout?");
  //               },
  //               child:
  //                   Text('Sign Out', style: TextStyle(color: Colors.lightBlue)),
  //             ),
  //           )
  //         ],
  //       ),
  //     ) : Center(child: CircularProgressIndicator()),
  //   );
  // }
}
