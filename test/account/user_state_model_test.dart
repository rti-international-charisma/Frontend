
import 'package:charisma/account/user_state_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('it should set logged in state', (){

    final userState = UserStateModel();

     userState.addListener(() {
       expect(userState.isLoggedIn, true);
     });

     userState.userLoggedIn();

  });

  test('it should set logged out state', (){

    final userState = UserStateModel();

    userState.addListener(() {
      expect(userState.isLoggedIn, false);
    });

    userState.userLoggedOut();

  });
}