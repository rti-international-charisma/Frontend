import 'package:charisma/account/signup_page_widget.dart';
import 'package:charisma/common/charisma_dropdown_widget.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../util/utils.dart';

void main() {
  MockApiClient apiClient = MockApiClient();
  MockRouterDelegate routerDelegate = MockRouterDelegate();
  List<dynamic> secQuestions = [
    {"id": 1, "question": "What was your favourite sport in high school?"},
    {"id": 2, "question": "What was your favourite sport in high school?"},
    {
      "id": 3,
      "question": "What is the title and artist of your favourite song?"
    },
    {"id": 4, "question": "What is your grandmother's first name?"},
    {
      "id": 5,
      "question": "What is the name of the boy or girl that you first kissed?"
    },
    {"id": 6, "question": "What was your childhood nickname?"}
  ];

  testWidgets('should render form fields', (WidgetTester tester) async {
    when(apiClient.get('/securityquestions/')).thenAnswer(
        (realInvocation) => Future<List<dynamic>>.value(secQuestions));

    await tester.pumpWidget(SignUpWidget(apiClient).wrapWithMaterial());

    expect(find.byKey(ValueKey('username')), findsOneWidget);
    expect(find.byKey(ValueKey('password')), findsOneWidget);
    expect(find.byKey(ValueKey('confirmpassword')), findsOneWidget);
    expect(find.byKey(ValueKey('SecurityQuestionsAnswer')), findsOneWidget);
    expect(find.byType(CharismaDropdown), findsOneWidget);
  });

  testWidgets('login now should take to Login page',
      (WidgetTester tester) async {
    when(apiClient.get('/securityquestions/')).thenAnswer(
        (realInvocation) => Future<List<dynamic>>.value(secQuestions));

    await tester.pumpWidget(
        SignUpWidget(apiClient).wrapWithMaterialMockRouter(routerDelegate));

    await tester.drag(
        find.byKey(ValueKey('MainContainerKey')), Offset(0.0, -200));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('loginButtonkey')));
    await tester.pump();

    verify(routerDelegate.push(LoginPageConfig));
  });

  testWidgets('should show username exist error', (WidgetTester tester) async {
    when(apiClient.get('/securityquestions/')).thenAnswer(
        (realInvocation) => Future<List<dynamic>>.value(secQuestions));

    var username = 'username';
    when(apiClient.get('/user/availability/$username')).thenAnswer(
        (realInvocation) =>
            Future<Map<String, dynamic>>.value({"available": false}));

    await tester.pumpWidget(SignUpWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('username')), 'username');
    await tester.pump();

    //Tap on different widget to loose focus
    await tester.tap(find.byKey(ValueKey('password')));
    await tester.pump();

    expect(find.text('Username entered already exists'), findsOneWidget);
  });

  testWidgets('should show password criteria popup',
      (WidgetTester tester) async {
    when(apiClient.get('/securityquestions/')).thenAnswer(
        (realInvocation) => Future<List<dynamic>>.value(secQuestions));
    var invalidPassword = 'asdf';
    await tester.pumpWidget(SignUpWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('password')), invalidPassword);
    await tester.pump();

    //Tap on different widget to loose focus
    await tester.tap(find.byKey(ValueKey('confirmpassword')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('should not show password criteria popup if password is valid',
      (WidgetTester tester) async {
    when(apiClient.get('/securityquestions/')).thenAnswer(
        (realInvocation) => Future<List<dynamic>>.value(secQuestions));
    var validPassword = 'Asdf@1234';
    await tester.pumpWidget(SignUpWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('password')), validPassword);
    await tester.pump();

    //Tap on different widget to loose focus
    await tester.tap(find.byKey(ValueKey('confirmpassword')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('should show passwords dont match error',
      (WidgetTester tester) async {
    when(apiClient.get('/securityquestions/')).thenAnswer(
        (realInvocation) => Future<List<dynamic>>.value(secQuestions));
    var passwordText = 'asdf';
    var confirmPasswordText = 'pqrs';

    await tester.pumpWidget(SignUpWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('password')), passwordText);
    await tester.pump(Duration(seconds: 1));

    await tester.enterText(
        find.byKey(ValueKey('confirmpassword')), confirmPasswordText);
    await tester.pump(Duration(seconds: 1));

    //Tap on different widget to loose focus
    await tester.tap(find.byKey(ValueKey('SecurityQuestionsAnswer')));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
