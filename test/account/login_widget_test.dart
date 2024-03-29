import 'package:charisma/account/login_page_widget.dart';
import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/utils.dart';

void main() {
  MockApiClient apiClient = MockApiClient();
  MockRouterDelegate routerDelegate = MockRouterDelegate();

  testWidgets('should render form fields', (WidgetTester tester) async {
    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterial());

    expect(find.byKey(ValueKey('LoginUNameKey')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginPWordKey')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginForgotPWordKey')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginLoginBtnKey')), findsOneWidget);
  });

  testWidgets('tapping on register now should take to Signup page',
      (WidgetTester tester) async {
    var userStateModel = UserStateModel();
        userStateModel.userLoggedIn();
        await tester.pumpWidget(
            LoginWidget(apiClient).wrapWithMaterialMockRouterUserState(routerDelegate, userStateModel));

    await tester.tap(find.byKey(ValueKey('LoginRegisterBtnKey')));
    await tester.pump();

    verify(routerDelegate.replace(SignUpConfig));
  });

  testWidgets('tapping on forgot password should take to Reset Password page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        LoginWidget(apiClient).wrapWithMaterialMockRouter(routerDelegate));

    await tester.tap(find.byKey(ValueKey('LoginForgotPWordKey')));
    await tester.pump();

    verify(routerDelegate.replace(ForgotPasswordConfig));
  });

  testWidgets('should show error if username is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('LoginPWordKey')), 'password');
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('LoginLoginBtnKey')));
    await tester.pump();

    expect(find.text('Cannot be empty'), findsOneWidget);
  });

  testWidgets('should show error if password is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(LoginWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('LoginUNameKey')), 'username');
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('LoginLoginBtnKey')));
    await tester.pump();

    expect(find.text('Cannot be empty'), findsOneWidget);
  });

  testWidgets('should go to Home Page on successful login',
      (WidgetTester tester) async {
    var username = 'username';
    var password = 'password';
    Map<String, dynamic> loginData = <String, dynamic>{
      "username": username,
      "password": password
    };

    var futureResponse = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": "some.jwt.token"
    });

    SharedPreferences.setMockInitialValues({});

    when(apiClient.post('/login', loginData))
        .thenAnswer((_) async => futureResponse);
    var userStateModel = UserStateModel();
    userStateModel.userLoggedIn();
    await tester.pumpWidget(
        LoginWidget(apiClient).wrapWithMaterialMockRouterUserState(routerDelegate, userStateModel));

    await tester.enterText(find.byKey(ValueKey('LoginUNameKey')), username);
    await tester.pump();

    await tester.enterText(find.byKey(ValueKey('LoginPWordKey')), password);
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('LoginLoginBtnKey')));
    await tester.pump();

    verify(routerDelegate.replace(HomePageConfig));
  });
}
