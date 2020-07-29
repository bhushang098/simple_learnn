import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple/services/firestoreService.dart';

class PaidLecturesWidgit extends StatelessWidget {
  List<paidVidClass> _vidList;

  PaidLecturesWidgit(this._vidList);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _vidList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    splashColor: Colors.teal[100],
                    onTap: () {
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
                            navToPurchase(context, _vidList[index]);
                          }
                        });
                      }
                      print("Tapped>>>>" + _vidList[index].title.toString());
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.video_library,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                      title: Text(_vidList[index].title.toString()),
                      subtitle: Text(_vidList[index].author.toString()),
                      trailing: Text(
                          'Price ' + _vidList[index].price.toString() + ' Rs'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
            ],
          );
        });
  }

  void navToPurchase(BuildContext context, paidVidClass vod) {
    Navigator.pushNamed(context, '/PurchasePage', arguments: vod);
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
