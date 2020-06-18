import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple/services/firestoreService.dart';

class PurchasedCourseDetails extends StatefulWidget {
  @override
  _PurchasedCourseDetailsState createState() => _PurchasedCourseDetailsState();
}

class _PurchasedCourseDetailsState extends State<PurchasedCourseDetails> {
  String courseName;
  MyFStore fStore;

  @override
  void initState() {
    // TODO: implement initState
    fStore = new MyFStore();
    super.initState();
  }

  Future getpurchasedCourse(String courseName) async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection(courseName).getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    //FirebaseUser user = Provider.of<FirebaseUser>(context);
    courseName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text('Simple Learn'),
      ),
//      body: ListView.builder(
//          itemCount: _vidList.length,
//          itemBuilder: (BuildContext context, int index) {
//            return Column(
//              children: <Widget>[
//                SizedBox(
//                  height: 3,
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(5.0),
//                  child: Card(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(8.0),
//                    ),
//                    child: InkWell(
//                      splashColor: Colors.teal[100],
//                      onTap: () {
//                        print('Got url >>>>' + _vidList[index].url.toString());
//                        navToNewVidScreen(_vidList[index]);
//                      },
//                      child: ListTile(
//                        leading: Icon(
//                          Icons.video_library,
//                          size: 50,
//                          color: Colors.green,
//                        ),
//                        title: Text(
//                          _vidList[index].title,
//                          style: TextStyle(
//                            fontSize: 18,
//                          ),
//                        ),
//                        //subtitle: Text(finalList[index].split('>>').last),
//                        subtitle: Text(_vidList[index].author),
//                      ),
//                    ),
//                  ),
//                ),
//                SizedBox(
//                  height: 3,
//                ),
//              ],
//            );
//          }),

      body: FutureBuilder(
        future: getpurchasedCourse(courseName),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return ListView.builder(
                itemCount: snapShot.data.length,
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
                              print('Got url >>>>' +
                                  snapShot.data[index].data['url']);
                              navToNewVidScreen(new VideoClass(
                                  snapShot.data[index].data['title'],
                                  snapShot.data[index].data['url'],
                                  snapShot.data[index].data['author_name'],
                                  snapShot.data[index]
                                      .data[courseName.split('>>').first],
                                  snapShot.data[index].data['price']));
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.video_library,
                                size: 50,
                                color: Colors.green,
                              ),
                              title: Text(
                                snapShot.data[index].data['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              //subtitle: Text(finalList[index].split('>>').last),
                              subtitle: Text(
                                  snapShot.data[index].data['author_name']),
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
        },
      ),
    );
  }

  void navToNewVidScreen(VideoClass videoClass) {
    Navigator.pushNamed(context, '/NewVidScreen', arguments: videoClass);
  }
}
