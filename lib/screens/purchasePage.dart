import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      'key': 'rzp_test_H7IWycVqn3EvN1',
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
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Card(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    // Updater user Infop to firestore:
    addNewCourseEntry(vid.course);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
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
  }
}
