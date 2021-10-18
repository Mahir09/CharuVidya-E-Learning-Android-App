import 'package:flutter/material.dart';

// class SigninAlertBox extends StatelessWidget {
//   final String title;
//   final String discription;
//
//   SigninAlertBox({this.title, this.discription});
//
//   final Widget okButton = FlatButton(
//     child: Text("OK"),
//     onPressed: () {
//       // Navigator.of(context).pop();
//     },
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(discription),
//       actions: [
//         okButton,
//       ],
//     );
//   }
// }

// showAlertDialog(BuildContext context) {
//   // Create button
//   Widget okButton = FlatButton(
//     child: Text("OK"),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );
//
//   // Create AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text("Simple Alert"),
//     content: Text("This is an alert message."),
//     actions: [
//       okButton,
//     ],
//   );
//
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }