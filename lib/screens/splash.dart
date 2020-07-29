import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void navigationToNextPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Wrapper', (Route<dynamic> route) => false);
  }

  startSplashScreenTimer() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationToNextPage);
  }

  @override
  void initState() {
    super.initState();
    startSplashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
//    return user == null ? new LoginSignUp() : Home();
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Image.asset('images/splashimg.jpg'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.teal[200],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text('Simple Learning',
              style: TextStyle(
                fontFamily: 'Pacifico',
                letterSpacing: 2.9,
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(
            width: 200,
            child: Divider(
              color: Colors.teal[200],
            ),
          ),
        ],
      )),
    );
  }
}
