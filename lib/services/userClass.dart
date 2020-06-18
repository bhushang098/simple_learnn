class UserClass {
  String _uid, _mob_No, _email, _courseList;

  UserClass(this._uid, this._mob_No, this._email, this._courseList);

  get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  get mob_No => _mob_No;

  set mob_No(value) {
    _mob_No = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get courseList => _courseList;

  set courseList(value) {
    _courseList = value;
  }

  @override
  String toString() {
    // TODO: implement toString
    print('>>>>' + mob_No + '>>>>' + courseList + '>>' + email);
    return super.toString();
  }
}
