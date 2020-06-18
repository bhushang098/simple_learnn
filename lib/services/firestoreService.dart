import 'package:cloud_firestore/cloud_firestore.dart';

class MyFStore {
  final databaseReference = Firestore.instance;
  int NoOfVideos = 0;
  String authorName;
  int price;

  List<VideoClass> getVideoData() {
    List<VideoClass> videoList = [];
    databaseReference
        .collection('videos')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => videoList.add(buildVidClass(f)));
    });
    return videoList;
  }

  VideoClass buildVidClass(DocumentSnapshot f) {
    List<String> keyList = f.data.keys.toList();
    VideoClass vid = new VideoClass(
        f['title'], f['url'], f['author_name'], f['course_ame'], f['price']);
    return vid;
  }

  List<paidVidClass> getPaidVideoData() {
    List<paidVidClass> videoList = [];
    databaseReference
        .collection('paid_videos')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => videoList.add(buildPaidVidClass(f)));
    });
    return videoList;
  }

  CourseDetailsClass getCourseDetails(String CourseName) {
    databaseReference
        .collection(CourseName)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => getData(f));
    });

    return new CourseDetailsClass(
        authorName, CourseName.split('>>').first, price, NoOfVideos);
  }

  paidVidClass buildPaidVidClass(DocumentSnapshot f) {
    //List<String> keyList = f.data.keys.toList();
    paidVidClass vid = new paidVidClass(
        f['title'], f['url'], f['author_name'], f['course_name'], f['price']);
    return vid;
  }

  getData(DocumentSnapshot f) {
    NoOfVideos++;
    authorName = f['author_name'];
    price = num.parse(f['price']);
  }

  Future<List<VideoClass>> getPurchaseCourseData(String courseName) async {
    List<VideoClass> videoList = [];
    databaseReference
        .collection(courseName)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => videoList.add(buildVidClass(f)));
    });
    return videoList;
  }
}

class CourseDetailsClass {
  String _authorName, _courseName;
  int _price, _noOfVideos;

  CourseDetailsClass(
      this._authorName, this._courseName, this._price, this._noOfVideos);

  String get authorName => _authorName;

  set authorName(String value) {
    _authorName = value;
  }

  get courseName => _courseName;

  set courseName(value) {
    _courseName = value;
  }

  int get price => _price;

  set price(int value) {
    _price = value;
  }

  get noOfVideos => _noOfVideos;

  set noOfVideos(value) {
    _noOfVideos = value;
  }
}

class VideoClass {
  String _title, _url, _author, _course, _price;

  VideoClass(this._title, this._url, this._author, this._course, this._price);

  get course => _course;

  set course(value) {
    _course = value;
  }

  get price => _price;

  set price(value) {
    _price = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  get url => _url;

  set url(value) {
    _url = value;
  }

  get author => _author;

  set author(value) {
    _author = value;
  }
}

class paidVidClass {
  String _title, _url, _author, _course, _price;

  paidVidClass(this._title, this._url, this._author, this._course, this._price);

  get price => _price;

  set price(value) {
    _price = value;
  }

  get course => _course;

  set course(value) {
    _course = value;
  }

  get author => _author;

  set author(value) {
    _author = value;
  }

  get url => _url;

  set url(value) {
    _url = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}
