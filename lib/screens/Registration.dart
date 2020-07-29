import 'package:flutter/material.dart';
import 'package:simple/services/authentication.dart';
import 'package:simple/services/dbCollectinService.dart';
import 'package:simple/services/parser.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final cpassward = TextEditingController();
  final cmail = TextEditingController();
  final cphoneNo = TextEditingController();

  bool _isLoading = false;
  final _auth = new Auth();

  void navigateToHome() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/StudMain', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register to simple Learn'),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E Mail ',
                    ),
                    controller: cmail,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'PassWord',
                    ),
                    controller: cpassward,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone No',
                    ),
                    controller: cphoneNo,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _isLoading ? CircularProgressIndicator() : Text(''),
                  RaisedButton(
                    color: Colors.teal,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      String mail, pass, phone;
                      pass = cpassward.text;
                      mail = cmail.text;
                      phone = cphoneNo.text;
                      if (mail.isEmpty || pass.isEmpty || phone.isEmpty) {
                        setState(() {
                          _isLoading = false;
                        });
                        showDialog(
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
                        dynamic user = await _auth.signUp(mail, pass, context);
                        if (user != null) {
                          setState(() {
                            _isLoading = false;
                          });
                          new DbUserCollection(user)
                              .pushUserdata(mail, phone, '0');
                          navigateToHome();
                          print('>>>>>>>>>>>>>>>>>>' + user);
                        } else {}
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
