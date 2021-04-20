
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
    "assessment": [ {
      "section": "section 1",
      "introduction": "Introduction for section 1",
      "questions": [ {
        "text": "question 1",
        "description": "description 1",
        "options": [ {
          "text": "disagree",
          "weightage": 2
        }, {
          "text": "agree",
          "weightage": 4
        }, {
          "text": "neutral",
          "weightage": 3
        }
        ]
      }, {
        "text": "question 3",
        "description": "description 3",
        "options": [ {
          "text": "agree",
          "weightage": 4
        }, {
          "text": "disagree",
          "weightage": 2
        }
        ]
      }
      ]
    }, {
      "section": "section 2",
      "introduction": "introduction for section 2",
      "questions": [ {
        "text": "question 2",
        "description": "description 2",
        "options": [ {
          "text": "disagree",
          "weightage": 2
        }, {
          "text": "strongly disagree",
          "weightage": 1
        }, {
          "text": "neutral",
          "weightage": 3
        }, {
          "text": "agree",
          "weightage": 4
        }, {
          "text": "strongly agree",
          "weightage": 5
        }
        ]
      }
      ]
    }
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

  testWidgets('it should display section', (WidgetTester tester) async {

    when(apiClient.get("/assessment"))
        .thenAnswer((realInvocation) => Future<Map<String, dynamic>?>.value(heartAssessment));

    await tester.pumpWidget(HeartAssessmentQuestionnaireWidget(apiClient: apiClient).wrapWithMaterial());
    await tester.pump();

    expect(find.textContaining('Section 1 of 2'), findsOneWidget);
    expect(find.textContaining('Introduction for section 1'), findsOneWidget);
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
