
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
    var userDataEncoded = prefs.getString('userData');
    return userDataEncoded != null ? convert.jsonDecode(userDataEncoded)['token'] : null;
  }
}