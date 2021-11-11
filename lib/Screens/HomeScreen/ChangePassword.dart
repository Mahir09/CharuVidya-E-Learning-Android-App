import 'package:charuvidya/Components/original_button.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
              //key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      //controller: TextEditingController(text: user.email),
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        hintText: 'ex: Pass@123',
                      ),
                      onChanged: (value) {
                        // user.email = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid username'
                          : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      // controller: TextEditingController(text: user.password),
                      decoration: InputDecoration(
                        labelText: 'Enter New Password',
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        //user.password = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid password'
                          : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      // controller: TextEditingController(text: user.password),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        //user.password = value;
                      },
                      validator: (value) => value.isEmpty
                          ? 'You must enter a valid password'
                          : null,
                    ),
                    SizedBox(height: 20),
                    OriginalButton(
                      text: 'Confirm',
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      onPressed: () async {},
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
