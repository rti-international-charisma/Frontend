
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/heart_assessment/charisma_heart_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment_question.dart';
import 'package:charisma/heart_assessment/heart_assessment_questionnaire.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

void main() {

  ApiClient apiClient = MockApiClient();
  Map<String, dynamic> heartAssessment = {
    "assessment": [
      {
        "id": "3a9be2a0-ea29-40ee-973c-d183af87996f",
        "section": "TRADITIONAL VALUES",
        "introduction": "This first section is about how do you feel about the kind of roles that men and women should have in their everyday lives.",
        "questions": [
          {
            "id": "0368f445-7cd9-430b-9ba3-2ca581020921",
            "text": "Changing diapers, giving the children a bath, and feeding the kids is a mother's responsibility.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          },
          {
            "id": "eaf1eeee-f329-46bf-94ce-03b93d67a75f",
            "text": "A woman cannot refuse to have sex with her husband or boyfriend.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          },
        ]
      },
      {
        "id": "fafcdc7a-4be6-4cf3-82e5-9ddde66479bf",
        "section": "PARTNER SUPPORT",
        "introduction": "Consider how much or how little support you might receive or have received from the partner you were thinking of in section 1",
        "questions": [
          {
            "id": "dda3380d-fee4-46a5-b00b-e60e405b21ea",
            "text": "My partner is as committed as I am to our relationship.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          },
        ]
      },
    ]
  };


  testWidgets('it should display widgets', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    expect(find.byType(CharismaHEARTAppBar), findsOneWidget);
    expect(find.byKey(ValueKey('HAAppBar')), findsWidgets);
    expect(find.byKey(ValueKey('HAMainScroll')), findsWidgets);
    expect(find.byKey(ValueKey('HANextDoneButton')), findsWidgets);
    expect(find.byKey(ValueKey('HABackButton')), findsWidgets);
    expect(find.byType(QuestionWidget), findsWidgets);
  });

  testWidgets('it should display correct number of question widgets', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    expect(find.byType(QuestionWidget), findsNWidgets(2));
  });

  testWidgets('it should display sections', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    expect(find.textContaining('Section 1 of 2'), findsOneWidget);
    expect(find.textContaining('TRADITIONAL VALUES'), findsOneWidget);
  });

  testWidgets('it should display error if all Questions not answered', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -600));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('HANextDoneButton')));
    await tester.pumpAndSettle();

    expect(find.text('Please answer all the questions.'), findsOneWidget);

  });

  testWidgets('it should change section', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('HAQuestion_1')));
    await tester.pump();

    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -400));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('HAQuestion_2')));
    await tester.pump();

    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -600));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('HANextDoneButton')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Section 2 of 2'), findsOneWidget);

  });

  testWidgets('it should change section on back', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    //Select option on question 1
    await tester.tap(find.byKey(ValueKey('HAQuestion_1')));
    await tester.pump();

    //scroll down
    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -400));
    await tester.pump();

    //Select option on question 2
    await tester.tap(find.byKey(ValueKey('HAQuestion_2')));
    await tester.pump();

    //Scroll down
    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -600));
    await tester.pump();

    //Tap next to move to next section
    await tester.tap(find.byKey(ValueKey('HANextDoneButton')));
    await tester.pumpAndSettle();

    //Scroll down on section 2
    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -200));
    await tester.pump();

    //Tap Back on section 2
    await tester.tap(find.byKey(ValueKey('HABackButton')));
    await tester.pumpAndSettle();

    //Should display section 1
    expect(find.textContaining('Section 1 of 2'), findsOneWidget);
  });

  testWidgets('it should not change section on back if you are on first section', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    expect(find.textContaining('Section 1 of 2'), findsOneWidget);

    //Scroll down
    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -600));
    await tester.pump();

    //Tap Back on section 1
    await tester.tap(find.byKey(ValueKey('HABackButton')));
    await tester.pumpAndSettle();

    //Should display section 1
    expect(find.textContaining('Section 1 of 2'), findsOneWidget);
  });

}

class MockApiClient extends Mock implements ApiClient {}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
    providers: [
      InheritedProvider<CharismaRouterDelegate>(
          create: (ctx) => CharismaRouterDelegate(MockApiClient()))
    ],
    child: MaterialApp(
        home: Scaffold(
          body: this,
        )),
  );
}
