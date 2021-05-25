import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import '../util/utils.dart';

void main() {
  testWidgets(
      'It displays app bar containing Charisma logo, Sign Up and Login link, instead of the logout link when the user is not signed in',
      (WidgetTester tester) async {

        var userStateModel = UserStateModel();
        userStateModel.userLoggedOut();
        await tester.pumpWidget(CharismaAppBar().wrapWithMaterialAndUserState(userStateModel));
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('SignUpLink')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginLink')), findsOneWidget);
    expect(find.byKey(ValueKey('CharismaLogo')), findsOneWidget);
    expect(find.byKey(ValueKey('LogoutLink')), findsNothing);
  });

  testWidgets(
      'It displays logout, instead of the Sign Up & Login links',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    var userData = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": "some.jwt.token"
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userData.then((value) =>
        preferences.setString('userData', convert.jsonEncode(value)));
    var userStateModel = UserStateModel();
    userStateModel.userLoggedIn();
    await tester.pumpWidget(CharismaAppBar().wrapWithMaterialAndUserState(userStateModel));
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('LogoutLink')), findsOneWidget);
    expect(find.byKey(ValueKey('SignUpLink')), findsNothing);
    expect(find.byKey(ValueKey('LoginLink')), findsNothing);

    // Resetting this data so that it doesn't interfere with other tests below
    preferences.setString('userData', '');
  });
}
