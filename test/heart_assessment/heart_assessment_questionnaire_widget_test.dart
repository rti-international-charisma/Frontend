import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/heart_assessment/charisma_heart_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment_question.dart';
import 'package:charisma/heart_assessment/heart_assessment_questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/utils.dart';
import 'dart:convert' as convert;

void main() {
  ApiClient apiClient = MockApiClient();
  Map<String, dynamic> heartAssessment = {
    "assessment": [
      {
        "id": "c8aca8b8-d22e-4291-b60e-08a878dac42a",
        "section": "TRADITIONAL VALUES",
        "introduction":
            "This first section is about how do you feel about the kind of roles that men and women should have in their everyday lives.",
        "questions": [
          {
            "id": "53e79da3-d07a-4f13-81af-b09170a52360",
            "text":
                "Changing diapers, giving the children a bath, and feeding the kids is a mother's responsibility.",
            "description": "",
            "options": [
              {"text": "Agree Strongly", "weightage": 6},
              {"text": "Strongly disagree", "weightage": 1},
              {"text": "Little", "weightage": 4},
              {"text": "Neutral", "weightage": 3},
              {"text": "Disagree", "weightage": 2},
              {"text": "Agree", "weightage": 5}
            ],
            "positiveNarrative": true
          },
          {
            "id": "d33111eb-96fb-4a74-8162-dea5850ed4ee",
            "text":
                "A woman cannot refuse to have sex with her husband or boyfriend.",
            "description": "",
            "options": [
              {"text": "Agree Strongly", "weightage": 6},
              {"text": "Strongly disagree", "weightage": 1},
              {"text": "Little", "weightage": 4},
              {"text": "Neutral", "weightage": 3},
              {"text": "Disagree", "weightage": 2},
              {"text": "Agree", "weightage": 5}
            ],
            "positiveNarrative": true
          },
        ]
      },
      {
        "id": "3a9be2a0-ea29-40ee-973c-d183af87996f",
        "section": "PARTNER SUPPORT",
        "introduction":
            "Consider how much or how little support you might receive or have received from the partner you were thinking of in section 1",
        "questions": [
          {
            "id": "61241d26-3afb-47b7-97ce-46df9c1c42bd",
            "text": "My partner is as committed as I am to our relationship.",
            "description": "",
            "options": [
              {"text": "Agree Strongly", "weightage": 6},
              {"text": "Strongly disagree", "weightage": 1},
              {"text": "Little", "weightage": 4},
              {"text": "Neutral", "weightage": 3},
              {"text": "Disagree", "weightage": 2},
              {"text": "Agree", "weightage": 5}
            ],
            "positiveNarrative": true
          },
        ]
      },
    ]
  };

  var partiallyCompletedAssessmentScoresData = {
    "sections": [
      {
        "sectionId": "c8aca8b8-d22e-4291-b60e-08a878dac42a",
        "sectionType": "PARTNER CONTEXT",
        "answers": [
          {"questionId": "53e79da3-d07a-4f13-81af-b09170a52360", "score": 2},
          {"questionId": "d33111eb-96fb-4a74-8162-dea5850ed4ee", "score": 1},
        ]
      }
    ],
    "totalSections" : 2
  };

  var unAttemptedScoresData = {
    "sections": [],
    "totalSections": 0
  };

  testWidgets('it should display widgets', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
        Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await tester.pump();

    expect(find.byType(CharismaHEARTAppBar), findsOneWidget);
    expect(find.byKey(ValueKey('HAAppBar')), findsWidgets);
    expect(find.byKey(ValueKey('HAMainScroll')), findsWidgets);
    expect(find.byKey(ValueKey('HANextDoneButton')), findsWidgets);
    expect(find.byKey(ValueKey('HABackButton')), findsWidgets);
    expect(find.byType(QuestionWidget), findsWidgets);
  });

  testWidgets('it should display correct number of question widgets',
      (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({});
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
        Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await tester.pump();

    expect(find.byType(QuestionWidget), findsNWidgets(2));
  });

  testWidgets('it should display sections', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
        Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await tester.pump();

    expect(find.textContaining('Section 1 of 2'), findsOneWidget);
    expect(find.textContaining('TRADITIONAL VALUES'), findsOneWidget);
  });

  testWidgets('it should display error if all Questions not answered',
      (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({});
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
        Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await tester.pump();

    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -600));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('HANextDoneButton')));
    await tester.pumpAndSettle();

    expect(find.text('Please answer all the questions.'), findsOneWidget);
  });

  testWidgets('it should change section', (WidgetTester tester) async {
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
        Future<Map<String, dynamic>?>.value(heartAssessment));
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
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
    SharedPreferences.setMockInitialValues({});
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
        Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
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

  testWidgets(
      'it should not change section on back if you are on first section',
      (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({});
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
        Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
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

  testWidgets('it should not post partial scores when user is not logged in', (WidgetTester tester) async {
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
    Future<Map<String, dynamic>?>.value(heartAssessment));
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
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

    verifyNever(apiClient.postWithHeaders('assessment/scores', any, any));
  });


  testWidgets('it should post partial scores when user is logged in', (WidgetTester tester) async {
    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
      Future<Map<String, dynamic>?>.value(heartAssessment));

    SharedPreferences.setMockInitialValues({});
    String userToken = "some.jwt.token";
    var userData = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": userToken
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userData.then((value) =>
        preferences.setString('userData', convert.jsonEncode(value)));

    var results = Future<Map<String, dynamic>>.value(unAttemptedScoresData);
    when(apiClient.getScores(userToken)).thenAnswer((_) => results);

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
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

    verify(apiClient.postWithHeaders('assessment/scores', any, any));
  });

  testWidgets('it should show selected icon for attempted questions answer when you go back', (WidgetTester tester) async{

    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
    Future<Map<String, dynamic>?>.value(heartAssessment));

    SharedPreferences.setMockInitialValues({});
    String userToken = "some.jwt.token";
    var userData = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": userToken
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userData.then((value) =>
        preferences.setString('userData', convert.jsonEncode(value)));

    var results = Future<Map<String, dynamic>>.value(partiallyCompletedAssessmentScoresData);
    when(apiClient.getScores(userToken)).thenAnswer((_) => results);

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await tester.pump();

    //Scroll down on section 2
    await tester.drag(find.byKey(ValueKey('HAMainScroll')), Offset(0.0, -200));
    await tester.pump();

    //Tap Back on section 2
    await tester.tap(find.byKey(ValueKey('HABackButton')));
    await tester.pumpAndSettle();

    //Should display section 1
    expect(find.byIcon(Icons.radio_button_checked), findsNWidgets(2));
  });

  testWidgets('it should show section after the attempted section when resuming partially completed assessment', (WidgetTester tester) async{

    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
    Future<Map<String, dynamic>?>.value(heartAssessment));

    SharedPreferences.setMockInitialValues({});
    String userToken = "some.jwt.token";
    var userData = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": userToken
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userData.then((value) =>
        preferences.setString('userData', convert.jsonEncode(value)));

    var results = Future<Map<String, dynamic>>.value(partiallyCompletedAssessmentScoresData);
    when(apiClient.getScores(userToken)).thenAnswer((_) => results);

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await tester.pump();

    //Should display section 2
    expect(find.textContaining('Section 2 of 2'), findsOneWidget);
  });

  testWidgets('it should show 1st section when user has not attempted assessment', (WidgetTester tester) async{

    when(apiClient.get("/assessments")).thenAnswer((realInvocation) =>
    Future<Map<String, dynamic>?>.value(heartAssessment));

    SharedPreferences.setMockInitialValues({});
    String userToken = "some.jwt.token";
    var userData = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": userToken
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userData.then((value) =>
        preferences.setString('userData', convert.jsonEncode(value)));

    var results = Future<Map<String, dynamic>>.value(unAttemptedScoresData);
    when(apiClient.getScores(userToken)).thenAnswer((_) => results);

    await tester.pumpWidget(
        HeartAssessmentQuestionnaireWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await tester.pump();

    //Should display section 2
    expect(find.textContaining('Section 1 of 2'), findsOneWidget);
  });
}
