import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:simple/screens/paidLecturesWidgit.dart';
import 'package:simple/services/SearchService.dart';
import 'package:simple/services/authentication.dart';
import 'package:simple/services/dbCollectinService.dart';
import 'package:simple/services/firestoreService.dart';
import 'package:simple/services/userClass.dart';

import 'lecturesWidget.dart';

class StudMain extends StatefulWidget {
  @override
  _StudMainState createState() => _StudMainState();
}

class _StudMainState extends State<StudMain> {
  int _currentIndex = 0;
  MyFStore db = new MyFStore();
  Auth _auth = new Auth();
  String courseList;
  DbUserCollection usersColletion;
  UserClass thisuser;

  List<VideoClass> _vidList = [];

  List<VideoWidget> _vidVigList = [];

  List<paidVidClass> _paidVidList = [];

  List<PaidLecturesWidgit> _paidVidWigList = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    onTabTapped(0);
    onTabTapped(1);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    usersColletion = new DbUserCollection(user.uid);
    return new Scaffold(
      endDrawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage('images/example_logo.png'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                          color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () async {
                    if (user.isAnonymous) {
                      // user is a guest Dont Allow Further
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // Retrieve the text the that user has entered by using the
                            // TextEditingController.
                            content: Text(
                                'You Logged in As Guest To See Your Purchases LogOut and then LogIn With your Email'),
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
                          courseList =
                              await usersColletion.getCoursePurchases();
                          Navigator.pop(context);
                          navTopurchases(courseList);
                        }
                      });
                    }
                    print('You Tapped purchases');
                  },
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text(
                      'Your Purchases',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    if (user.isAnonymous) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // Retrieve the text the that user has entered by using the
                            // TextEditingController.
                            content: Text(
                                'You Logged in As Guest To See Your Downloads LogOut and then LogIn With your Email'),
                          );
                        },
                      );
                    } else {
                      navtoDownloaded();
                    }
                    print('You Tapped Diwnbloads');
                  },
                  child: ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text(
                      'Your Downloads',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Share.share(
                        'https://play.google.com/store/apps/details?id=edu.learn.simple');
                  },
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text(
                      'Share App ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    String url = 'https://nifty-carson-bbfde4.netlify.app' +
                        '??Contact Us';
                    Navigator.pop(context);
                    navTocontactUs(url);
                  },
                  child: ListTile(
                    leading: Icon(Icons.contact_mail),
                    title: Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    String url =
                        'https://inspiring-lumiere-ac799a.netlify.app' +
                            '??Terms And Conditions';
                    Navigator.pop(context);
                    navTocontactUs(url);
                  },
                  child: ListTile(
                    leading: Icon(Icons.note),
                    title: Text(
                      'Terms And Conditions',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () async {
                    await _auth.signOut();
                    navToLogin();
                    print('You Tapped LogOUt');
                  },
                  child: ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text(
                      'Log Out',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, //specify the location of the FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 0)
            showSearch(context: context, delegate: DeligateLectures(_vidList));
          else
            showSearch(
                context: context, delegate: DeligatePaidLectures(_paidVidList));
          // TODO navigate to serach page and pass list of widgits
          //navigateToSearchPage();
        },
        tooltip: "search for Lectures",
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Icon(Icons.search),
        ),
        elevation: 4.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        onTap: onTabTapped, // new
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.video_library),
            title: new Text('Free Lectures'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.ondemand_video),
            title: new Text('Paid Lectures'),
          ),
        ],
      ),
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Simple Learn'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
                print("u tapped person  ");
              }),
        ],
      ),
      body: _currentIndex == 0 ? _vidVigList[0] : _paidVidWigList[0],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        _vidList = db.getVideoData();
        _vidVigList.add(new VideoWidget(_vidList));
      }

      if (_currentIndex == 1) {
        _paidVidList = db.getPaidVideoData();
        _paidVidWigList.add(new PaidLecturesWidgit(_paidVidList));
      }
    });
  }

  void navTopurchases(String courseList) {
    Navigator.pushNamed(context, '/UserPurchases', arguments: courseList);
  }

  void navtoDownloaded() {
    Navigator.pushNamed(context, '/Downloads');
  }

  void navToLogin() {
    ///Navigator.pushNamed(context, '/loginSignUp');
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/loginSignUp', (Route<dynamic> route) => false);
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

  void navTocontactUs(String url) {
    Navigator.pushNamed(context, '/ContactUs', arguments: url);
  }
}
