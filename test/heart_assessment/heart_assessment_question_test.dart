

import 'package:charisma/heart_assessment/heart_assessment.dart';
import 'package:charisma/heart_assessment/heart_assessment_question.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../account/login_widget_test.dart';

void main() {

  testWidgets('it should display all widgets', (WidgetTester tester) async {
    var question = QuestionWidget(
        1,
        Question(
            id: "someid",
            text: 'question 1',
            description: 'description',
            options: [Option(text: 'option', weightage: 1)]),
            (qId, weightage) {}
    );

    await tester.pumpWidget(question.wrapWithMaterial());

    expect(find.byKey(ValueKey('questionIndex')), findsOneWidget);
    expect(find.byKey(ValueKey('questionText')), findsOneWidget);
  });

  testWidgets('it should display correct number of options', (WidgetTester tester) async {
    var question = QuestionWidget(
        1,
        Question(
            id: "someid",
            text: 'question 1',
            description: 'description',
            options: [
              Option(text: 'option1', weightage: 1),
              Option(text: 'option2', weightage: 2),
              Option(text: 'option3', weightage: 3),
            ]),
            (qId, weightage) {}
    );

    await tester.pumpWidget(question.wrapWithMaterial());

    expect(find.text('option1'), findsOneWidget);
    expect(find.text('option2'), findsOneWidget);
    expect(find.text('option3'), findsOneWidget);
  });

  testWidgets('it should show selected option', (WidgetTester tester) async {
    var question = QuestionWidget(
        1,
        Question(
            id: "someid",
            text: 'question 1',
            description: 'description',
            options: [
              Option(text: 'option1', weightage: 1),
              Option(text: 'option2', weightage: 2),
              Option(text: 'option3', weightage: 3),
            ]),
            (qId, weightage) {}
    );

    await tester.pumpWidget(question.wrapWithMaterial());

    await tester.tap(find.text('option2'));
    await tester.pump();

    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
  });

}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
    providers: [
      InheritedProvider<CharismaRouterDelegate>(
          create: (ctx) => CharismaRouterDelegate(MockApiClient())
      )
    ],
    child: MaterialApp(
        home: Scaffold(
          body: this,
        )),
  );
}