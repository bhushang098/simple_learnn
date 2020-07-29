import 'dart:collection';
import 'dart:core';

class Parser {
  HashSet errorset;
  var erroeMess = [];

  String s;

  Parser(String s) {
    this.s = s;

    erroeMess = s.split(" ");

//    for(String str :  erroeMess)
//    {
//      errorset.add(str);
//    }

    erroeMess.forEach((f) {
      errorset.add(f);
    });
  }

  bool checkERorForWrongpass() {
    if (errorset.contains("password") && errorset.contains("invalid"))
      return true;

    return false;
  }

  bool checkAlreadyuser() {
    if (errorset.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
      return true;
    }
    return false;
  }

  bool checkuserNotExists() {
    if (errorset.contains("no") &&
        errorset.contains("record") &&
        errorset.contains("deleted.")) return true;

    return false;
  }

  bool checkTooMayAttempts() {
    if (errorset.contains("Too") &&
        errorset.contains("many") &&
        errorset.contains("attempts.")) return true;

    return false;
  }
}
