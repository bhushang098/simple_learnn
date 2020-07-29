import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple/services/authentication.dart';

class PassReset extends StatefulWidget {
  @override
  _PassResetState createState() => _PassResetState();
}

class _PassResetState extends State<PassReset> {
  Auth _auth;
  TextEditingController email = TextEditingController();
  String sMail;

  @override
  void initState() {
    // TODO: implement initState
    _auth = new Auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E Mail',
              ),
              controller: email,
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: Colors.teal,
              onPressed: () {
                sMail = email.text.trim();
                if (sMail.isEmpty) {
                  Fluttertoast.showToast(msg: 'Provide Mail');
                } else {
                  _auth.resetPassword(sMail).then((onValue) {
                    Fluttertoast.showToast(
                        msg: 'Password Reset Link Sent To your Mail');
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text(
                'Reset Password',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
