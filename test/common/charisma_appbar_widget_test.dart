import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/common/shared_preference_helper.dart';

import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/network_image_builder_mock.dart';

void main() {
  testWidgets(
      'It displays app bar containing Charisma logo, Sign Up and Login link, instead of the user greeting when the user is not signed in',
      (WidgetTester tester) async {
    await tester.pumpWidget(CharismaAppBar().wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('SignUpLink')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginLink')), findsOneWidget);
    expect(find.byKey(ValueKey('UserName')), findsNothing);
    expect(find.byKey(ValueKey('CharismaLogo')), findsOneWidget);
  });

  testWidgets(
      'It displays user greeting in the app bar when signed in, instead of the Sign Up & Login links',
      (WidgetTester tester) async {
    final sharedPreferenceHelper = MockSharedPreferencesHelper();
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

    when(sharedPreferenceHelper.getUserData()).thenAnswer((_) => userData);

    await tester.pumpWidget(CharismaAppBar().wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('SignUpLink')), findsNothing);
    expect(find.byKey(ValueKey('LoginLink')), findsNothing);
    expect(find.byKey(ValueKey('UserName')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('UserName')).evaluate().single.widget as Text)
            .data,
        equals('Hi username!'));

    // Resetting this data so that it doesn't interfere with other tests below
    preferences.setString('userData', '');
  });
}

class MockApiClient extends Mock implements ApiClient {}

class MockSharedPreferencesHelper extends Mock
    implements SharedPreferenceHelper {}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (ctx) => MockNetworkImageBuilder()),
          Provider<Future<SharedPreferences>>(
              create: (_) => SharedPreferences.getInstance()),
          InheritedProvider<CharismaRouterDelegate>(
              create: (ctx) => CharismaRouterDelegate(MockApiClient()))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: this,
        )),
      );
}
