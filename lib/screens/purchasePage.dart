import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:simple/services/firestoreService.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  var vid;
  CourseDetailsClass courseDetails;
  Razorpay _razorpay;
  FirebaseUser user;
  String mobNo, email;
  // var courseList;

  @override
  void initState() {
    // TODO: implement initState

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_SFkrMpkKL4FzIe',
      'amount': num.parse(vid.price) * 100,
      'name': vid.author,
      'description': 'Course name : ' + vid.course.toString().split('>>').first,
      'prefill': {'contact': mobNo, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    vid = ModalRoute.of(context).settings.arguments;

    getUserdata(user);
    //courseDetails = new MyFStore().getCourseDetails(vid.course);

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text('Make Purchase'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Course Name : ' +
                        vid.course.split('>>').first +
                        '\n\n' +
                        'Price : ' +
                        vid.price +
                        ' Rs'
                            '\n\n' +
                        'Author : ' +
                        vid.author +
                        '\n\n',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[700],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Note :- when ${vid.author} uploads new Videos In Course ${vid.course.split('>>').first} it will be updated in your Purchased course for free and u have Access to this course provided  you have your email and Password to access your Account \n '),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              child: Text(
                'Purchase This Course',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.teal,
              onPressed: () {
                //ToDO : open razor pay
                openCheckout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
//
    addNewCourseEntry(vid.course);

    updateTeachersCourseSoldInfoandbalance(vid.course);

    showAlertDialog(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: Text('Opps !!! \n Payment Failed'),
        );
      },
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: Text(
            'Sorry !!! \n We Dont Support ' + response.walletName,
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Future addNewCourseEntry(String courseName) async {
    CollectionReference studentsCollection =
        Firestore.instance.collection('users');

    DocumentSnapshot studentSnapShot =
        await Firestore.instance.collection('users').document(user.uid).get();
    var courseBuyedTill = studentSnapShot['courses_purchases'];
    return await studentsCollection.document(user.uid).updateData({
      'courses_purchases': courseBuyedTill.toString() + '??.??' + courseName,
    });
  }

  void getUserdata(FirebaseUser user) async {
    DocumentSnapshot studentSnapshot =
        await Firestore.instance.collection('users').document(user.uid).get();
    mobNo = studentSnapshot['mobile_no'];
    email = studentSnapshot['email'];
    //courseList = studentSnapshot['courses_purchases'];
  }

  void navTouHome() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/StudMain', (Route<dynamic> route) => false);
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Return Home"),
      onPressed: () {
        Navigator.of(context).pop();
        navTouHome();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Congratulations !!!"),
      content: Text(
          "you Purchased This Course \n see this course in Your Purchases option"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updateTeachersCourseSoldInfoandbalance(String courseName) async {
    CollectionReference TeachersCollection =
        Firestore.instance.collection('teachers');

    DocumentSnapshot teacherSnapShot = await Firestore.instance
        .collection('teachers')
        .document(courseName.split('>>').last)
        .get();
    var coursesSoldTill = teacherSnapShot['courses_sold'];
    double oldbalance = num.parse(teacherSnapShot['balance']);
    double newBalance = (oldbalance + ((78 / 100) * num.parse(vid.price)));
    print('>>>:::??????????::::::${newBalance}');
    return await TeachersCollection.document(courseName.split('>>').last)
        .updateData({
      'courses_sold': coursesSoldTill.toString() + '??.??' + courseName,
      'balance': newBalance.toStringAsFixed(2),
    });
  }
}
