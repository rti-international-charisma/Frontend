
import 'package:charisma/account/forgot_password_widget.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../util/utils.dart';

void main() {

  List<dynamic> secQuestions = [
    {"id": 1, "question": "What was your favourite sport in high school?"},
    {"id": 2, "question": "What is the title and artist of your favourite song?"}
  ];


  MockApiClient apiClient = MockApiClient();
  MockRouterDelegate routerDelegate = MockRouterDelegate();

  testWidgets('it should render all widget', (WidgetTester tester) async {

    when(apiClient.get('/securityquestions/'))
        .thenAnswer((realInvocation) => Future<List<dynamic>>.value(secQuestions));

    await tester.pumpWidget(ForgotPasswordWidget(apiClient).wrapWithMaterial());

    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('FPUsernameKey')), findsOneWidget);
    expect(find.byKey(ValueKey('FPSecQuestionsAnswer')), findsOneWidget);
    expect(find.byKey(ValueKey('FPNewPassButton')), findsOneWidget);
    expect(find.byKey(ValueKey('FPRegisterButtonKey')), findsOneWidget);

  });

  testWidgets('it should go to Signup page', (WidgetTester tester) async {

    when(apiClient.get('/securityquestions/'))
        .thenAnswer((realInvocation) => Future<List<dynamic>>.value(secQuestions));

    await tester.pumpWidget(ForgotPasswordWidget(apiClient).wrapWithMaterialMockRouter(routerDelegate));

    await tester.pump(Duration.zero);

    await tester.tap(find.byKey(ValueKey('FPRegisterButtonKey')));
    await tester.pump();

    verify(routerDelegate.push(SignUpConfig));

  });

  testWidgets('it should display select all the fields errors', (WidgetTester tester) async {

    when(apiClient.get('/securityquestions/'))
        .thenAnswer((realInvocation) => Future<List<dynamic>>.value(secQuestions));

    await tester.pumpWidget(ForgotPasswordWidget(apiClient).wrapWithMaterialMockRouter(routerDelegate));

    await tester.pump(Duration.zero);

    await tester.enterText(find.byKey(ValueKey('FPUsernameKey')), 'username');
    await tester.pump(Duration(seconds: 1));

    await tester.tap(find.byKey(ValueKey('FPNewPassButton')));
    await tester.pump();

    expect(find.text('Please select all the fields'), findsOneWidget);

  });

}