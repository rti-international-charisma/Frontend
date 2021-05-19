

import 'package:flutter/material.dart';

class UserStateModel extends ChangeNotifier {

  bool isLoggedIn = false;

  void userLoggedIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void userLoggedOut() {
    isLoggedIn = false;
    notifyListeners();
  }

}