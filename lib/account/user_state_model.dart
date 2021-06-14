import 'package:flutter/material.dart';

class UserStateModel extends ChangeNotifier {
  bool isLoggedIn = false;

  UserStateModel({this.isLoggedIn = false});

  void userLoggedIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void userLoggedOut() {
    // Logger.log('NOTIFY LOGOUT');
    isLoggedIn = false;
    notifyListeners();
  }
}
