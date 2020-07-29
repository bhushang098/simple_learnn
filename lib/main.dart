import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple/screens/NewVidScreen.dart';
import 'package:simple/screens/Registration.dart';
import 'package:simple/screens/aboutUs.dart';
import 'package:simple/screens/contactus.dart';
import 'package:simple/screens/downloadedVideoScreen.dart';
import 'package:simple/screens/downloads.dart';
import 'package:simple/screens/login_signup.dart';
import 'package:simple/screens/passReset.dart';
import 'package:simple/screens/purchasePage.dart';
import 'package:simple/screens/purchasedCourseDetails.dart';
import 'package:simple/screens/splash.dart';
import 'package:simple/screens/studentsMainpage.dart';
import 'package:simple/screens/userPurchases.dart';
import 'package:simple/screens/videoScreen.dart';
import 'package:simple/screens/wrapper.dart';
import 'package:simple/services/authentication.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: Auth().user,
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark,
          primaryColor: Colors.teal,
          //accentColor: Colors.cyan[600],
        ),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/loginSignUp': (BuildContext context) => new LoginSignUp(),
          '/Registeration': (BuildContext context) => new Registration(),
          '/StudMain': (BuildContext context) => new StudMain(),
          '/splash': (BuildContext context) => new Splash(),
          '/Wrapper': (BuildContext context) => new Wrapper(),
          '/vidScreen': (BuildContext context) => new VidScreen(),
          '/UserPurchases': (BuildContext context) => new UserPurchases(),
          '/Downloads': (BuildContext context) => new Downloaded(),
          '/PurchasePage': (BuildContext context) => new PurchasePage(),
          '/PurchasedCourseDetails': (BuildContext context) =>
              new PurchasedCourseDetails(),
          '/NewVidScreen': (BuildContext context) => new NewVidScreen(),
          '/AboutUs': (BuildContext context) => new AboutUs(),
          '/DownloadedVidScreen': (BuildContext context) =>
              new DownloadvidScreen(),
          '/ContactUs': (BuildContext context) => new ContactUs(),
          '/PassReset': (BuildContext context) => new PassReset(),
        },
        home: Splash(),
      ),
    );
  }
}
