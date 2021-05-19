import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class SharedPreferenceHelper {
  Future<T>? getUserData<T>() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDataEncoded = prefs.getString('userData');

    if (userDataEncoded == null) {
      return Map() as T;
    } else {
      return convert.jsonDecode(userDataEncoded)['user'] as T;
    }
  }

  Future<String?>? getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataEncoded = prefs.getString('userData');

    if (userDataEncoded != null) {
      return convert.jsonDecode(userDataEncoded)['token'];
    } else {
      return null;
    }
  }

  Future<String?>? getPasswordToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDataEncoded = prefs.getString('userData');
    return userDataEncoded != null
        ? convert.jsonDecode(userDataEncoded)['resetPasswordToken']
        : null;
  }

  Future<T>? getResultsData<T>() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var results = prefs.getString('results');

    if (results == null) {
      return Map() as T;
    } else {
      return convert.jsonDecode(results) as T;
    }
  }

  setUserData(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data == null) {
      prefs.remove('userData');
    } else {
      prefs.setString('userData', convert.jsonEncode(data));
    }
  }

  setResultsData(results) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('results', convert.jsonEncode(results));
  }
}
