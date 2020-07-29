import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple/screens/videoPlayer.dart';
import 'package:simple/services/firestoreService.dart';

class VidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoClass vid = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    return Stack(
      children: <Widget>[
        DefaultPlayer(vid.url),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FloatingActionButton(
            backgroundColor: Colors.teal[50],
            child: Icon(
              Icons.shopping_cart,
              color: Colors.teal,
              semanticLabel: 'Buy',
            ),
            tooltip: 'Buy This Course',
            onPressed: () {
              // <String ,string> {url:'url',name :'Name of Couse' etc.....}
              if (user.isAnonymous) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text(
                          'Guests Can not Purchase courses LogOut and then LogIn With your Email'),
                    );
                  },
                );
              } else {
                bool istechher = false;
                isTeacher(user).then((value) async {
                  istechher = value;
                  if (istechher) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the that user has entered by using the
                          // TextEditingController.
                          content: Text(
                              'This Mail Is Assigned With Teacher Account \n please create new Account For Students Side Access'),
                        );
                      },
                    );
                  } else {
                    navToPurchasePage(context, vid);
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  void navToPurchasePage(BuildContext context, VideoClass vid) {
    Navigator.pushNamed(context, '/PurchasePage', arguments: vid);
  }

  Future<bool> isTeacher(FirebaseUser user) async {
    DocumentSnapshot reference =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (reference.exists) {
      return false;
    } else {
      return true;
    }
  }
}
