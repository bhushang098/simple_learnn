import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple/services/authentication.dart';
import 'package:simple/services/dbCollectinService.dart';


class LoginSignUp extends StatefulWidget {
  @override
  _LoginSignUpState createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  final email = TextEditingController();
  final password = TextEditingController();
  final mobileNo = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _auth = new Auth();

  void navigateToStudMain() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/StudMain', (Route<dynamic> route) => false);
  }

  void openRegisterPage() {
    Navigator.pushNamed(context, '/Registeration');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Simple Learn'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email',
                  ),
                  controller: email,
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                  ),
                  controller: password,
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  color: Colors.teal,
                  onPressed: () async {
                    //TODo: perform Logon action
                    String mail = email.text;
                    String pass = password.text;
                    if (mail.isEmpty || pass.isEmpty) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // Retrieve the text the that user has entered by using the
                            // TextEditingController.
                            content: Text('provide all info'),
                          );
                        },
                      );
                    } else {
                      dynamic userid = await _auth.signIn(mail, pass);
                      if (userid == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the that user has entered by using the
                              // TextEditingController.
                              content: Text('failed login'),
                            );
                          },
                        );
                      } else {
                        navigateToStudMain();
                        print('>>>>>>>>>>>>>>>>>>' + userid.toString());
                      }
                    }
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Divider(
                    height: 2,
                    color: Colors.teal,
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile No',
                      ),
                      controller: mobileNo,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Colors.teal,
                      onPressed: () async {
                        //TODo: perform Guset Login Action
                        if (mobileNo.text.length == 10) {
                          dynamic userid = await _auth.signInAnon();
                          if (userid != null) {
                            new DbGuestUsersCollection(userid)
                                .pushGuestNo(mobileNo.text);
                            navigateToStudMain();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  // Retrieve the text the that user has entered by using the
                                  // TextEditingController.
                                  content: Text('Something went wrong'),
                                );
                              },
                            );
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // Retrieve the text the that user has entered by using the
                                // TextEditingController.
                                content: Text('invalid mobile number'),
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        'Explore As Guest',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Colors.teal,
                      onPressed: () {
                        openRegisterPage();
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
