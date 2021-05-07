
import 'package:charisma/account/set_new_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/utils.dart';

void main() {
  MockApiClient apiClient = MockApiClient();

  testWidgets('it should render form fields', (WidgetTester tester) async {

    await tester.pumpWidget(SetNewPasswordWidget(apiClient).wrapWithMaterial());

    expect(find.byKey(ValueKey('SPPasswordKey')), findsOneWidget);
    expect(find.byKey(ValueKey('SPConfirmPasswordKey')), findsOneWidget);
    expect(find.byKey(ValueKey('SPSetPassButton')), findsOneWidget);
  });

  testWidgets('it should show password criteria popup', (WidgetTester tester) async {

    await tester.pumpWidget(SetNewPasswordWidget(apiClient).wrapWithMaterial());

    await tester.enterText(find.byKey(ValueKey('SPPasswordKey')), 'invalidpassword');
    await tester.pump();

    //Tap on different widget to loose focus
    await tester.tap(find.byKey(ValueKey('SPConfirmPasswordKey')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('should not show password criteria popup if password is valid',
          (WidgetTester tester) async {

        var validPassword = 'Asdf@1234';
        await tester.pumpWidget(SetNewPasswordWidget(apiClient).wrapWithMaterial());

        await tester.enterText(find.byKey(ValueKey('SPPasswordKey')), validPassword);
        await tester.pump();

        //Tap on different widget to loose focus
        await tester.tap(find.byKey(ValueKey('SPConfirmPasswordKey')));
        await tester.pump();

        expect(find.byType(AlertDialog), findsNothing);
      });

  testWidgets('should show passwords dont match error',
          (WidgetTester tester) async {

        var passwordText = 'asdf';
        var confirmPasswordText = 'pqrs';

        await tester.pumpWidget(SetNewPasswordWidget(apiClient).wrapWithMaterial());

        await tester.enterText(find.byKey(ValueKey('SPPasswordKey')), passwordText);
        await tester.pump(Duration(seconds: 1));

        await tester.enterText(
            find.byKey(ValueKey('SPConfirmPasswordKey')), confirmPasswordText);
        await tester.pump(Duration(seconds: 1));

        //Tap on different widget to loose focus
        await tester.tap(find.byKey(ValueKey('SPSetPassButton')));
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });

}