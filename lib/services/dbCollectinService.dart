import 'package:cloud_firestore/cloud_firestore.dart';

class DbGuestUsersCollection {
  final String uid;

  DbGuestUsersCollection(this.uid);

  final CollectionReference guestCollection =
      Firestore.instance.collection('guests');

  Future pushGuestNo(String mobNo) async {
    return await guestCollection.document(uid).setData({'mobile_no': mobNo});
  }

  Future getGuestdata(String uid) async {
    return await guestCollection.getDocuments();
  }
}

class DbUserCollection {
  final String uid;

  DbUserCollection(this.uid);

  final CollectionReference users = Firestore.instance.collection('users');

  Future pushUserdata(
      String email, String mobNo, String coursePurchased) async {
    return await users.document(uid).setData({
      'email': email,
      'mobile_no': mobNo,
      'courses_purchases': coursePurchased
    });
  }

  Future<String> getCoursePurchases() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    var courseList = snapshot['courses_purchases'];
    if (courseList is String) {
      return courseList;
    } else {
      return 'empty';
    }
  }
}
