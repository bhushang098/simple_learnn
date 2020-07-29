import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple/services/firestoreService.dart';

class UserPurchases extends StatefulWidget {
  @override
  _UserPurchasesState createState() => _UserPurchasesState();
}

class _UserPurchasesState extends State<UserPurchases> {
  var courseList;
  var finalList;
  MyFStore fStore;

  @override
  void initState() {
    // TODO: implement initState
    fStore = new MyFStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    courseList =
        ModalRoute.of(context).settings.arguments.toString().split('??.??');
    finalList = courseList.sublist(1, courseList.length);

    return Scaffold(
        appBar: AppBar(
          title: Text('Yours Purchases'),
        ),
        backgroundColor: Colors.teal[50],
        body: finalList.length == 0
            ? Center(
                child: Text(
                'No Purchases',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: finalList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.teal[100],
                                onTap: () {
                                  print('Got Course >>>>' + finalList[index]);

                                  navToPurchasedCourseDetailsPage(
                                      finalList[index]);

                                  // Get CourseDetails
                                  //navtoVidScreen(widget._vidList[index]);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.video_library,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                    finalList[index].split('>>').first,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //subtitle: Text(finalList[index].split('>>').last),
                                  subtitle:
                                      Text('You Have Purchased This Course'),
                                  trailing: Icon(
                                    Icons.verified_user,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                        ],
                      );
                    }),
              ));
  }

  void navToPurchasedCourseDetailsPage(String courseName) {
    Navigator.pushNamed(context, '/PurchasedCourseDetails',
        arguments: courseName);
  }
}
