import 'package:charisma/heart_assessment/ha_landing_page_widget.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/utils.dart';
import 'dart:convert' as convert;

void main() {
  var pageContent = {
    "title": "HEART Assessment Introduction",
    "summary":
        "<p>&bull; &nbsp; &nbsp;Disagree or Agree, and then &nbsp;<br />&bull; &nbsp; &nbsp;How much you disagree or agree: A Lot, Somewhat or A Little</p>\n<p>And finally, try to answer the questions about yourself and about your relationship with your partner(s) as honestly and openly as you can. These questions will help determine what kind of counselling and support related to the use of PrEP you might need.&nbsp;</p>\n<p>Remember, all your answers will be kept confidential.</p>",
    "introduction":
        "<p><strong>Hi there, you&rsquo;re about to take the HEAlthy Relationship Assessment (HEART assessment).&nbsp;</strong><br /><strong>Go to you for taking this step!&nbsp;</strong></p>\n<p>We think it&rsquo;s useful to find out what limits or risks you might face in your relationship that could stop you from using PrEP. It may also help you see what&rsquo;s healthy or not in your relationship. We&rsquo;ll use your score to advise you on the content and skills we think could work for you in your relationship and PrEP use journey.&nbsp;</p>\n<p>When you&rsquo;re taking the HEART assessment, remember to keep your main partner in mind. If you don&rsquo;t have a main partner, it&rsquo;s helpful to think about which partner or partners might affect your PrEP use the most.&nbsp;</p>\n<p>A quick note about responding to the questions. For each question, you have 5 options based on how much you agree or disagree with the statement you&rsquo;re reading:</p>",
    "images": [
      {
        "title": "Image 18",
        "imageUrl": "/assets/76438d8d-bd12-453d-9793-8adf363c820e"
      }
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
          {"questionId": "1d369bb8-8373-4010-968b-313c11fa1af6", "score": 3}
        ]
      },
      {
        "sectionId": "3a9be2a0-ea29-40ee-973c-d183af87996f",
        "sectionType": "TRADITIONAL VALUES",
        "answers": [
          {"questionId": "61241d26-3afb-47b7-97ce-46df9c1c42bd", "score": 1},
          {"questionId": "0008ea62-937a-4dcb-9b01-5e145d82abbd", "score": 4}
        ]
      }
    ],
    "totalSections": 6
  };

  testWidgets('It displays app bar title', (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/content/assessment-intro"))
        .thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(pageContent);
    });

    await tester.pumpWidget(
        HALandingPageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HAPageTitle')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('HAPageTitle')).evaluate().single.widget as Text)
            .data,
        equals(pageContent['title']));
  });

  testWidgets('It displays page content', (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/content/assessment-intro"))
        .thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(pageContent);
    });

    await tester.pumpWidget(
        HALandingPageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HAIntro')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('HAIntro')).evaluate().single.widget as Html).data,
        equals(pageContent['introduction']));

    expect(find.byKey(ValueKey('HAIntroImage')), findsOneWidget);

    expect(find.byKey(ValueKey('HASummary')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('HASummary')).evaluate().single.widget as Html)
            .data,
        equals(pageContent['summary']));
  });

  testWidgets('It displays an action button named "Get started"',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/content/assessment-intro"))
        .thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(pageContent);
    });

    await tester.pumpWidget(
        HALandingPageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HAGetStarted')), findsOneWidget);
    expect(
        ((find.byKey(ValueKey('HAGetStarted')).evaluate().single.widget
                    as TextButton)
                .child as Text)
            .data,
        equals('Get started'));
  });

  testWidgets('it should go to heartAssessment Page on tap of Get Started',
      (WidgetTester tester) async {
    MockRouterDelegate routerDelegate = MockRouterDelegate();
    SharedPreferences.setMockInitialValues({});

    final apiClient = MockApiClient();

    when(apiClient.get("/content/assessment-intro"))
        .thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(pageContent);
    });

    await tester.pumpWidget(HALandingPageWidget(apiClient: apiClient)
        .wrapWithMaterialMockRouter(routerDelegate));
    await mockNetworkImagesFor(() => tester.pump());

    await tester.tap(find.byKey(ValueKey('HAGetStarted')));
    await tester.pump();

    verify(routerDelegate.push(HeartAssessmentQuestionnaireConfig));
  });

  testWidgets('it should show Continue text on partial assessment',
          (WidgetTester tester) async {
        MockRouterDelegate routerDelegate = MockRouterDelegate();

        final apiClient = MockApiClient();

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

        when(apiClient.get("/content/assessment-intro"))
            .thenAnswer((realInvocation) {
          return Future<Map<String, dynamic>>.value(pageContent);
        });

        await tester.pumpWidget(HALandingPageWidget(apiClient: apiClient)
            .wrapWithMaterialMockRouter(routerDelegate));
        await mockNetworkImagesFor(() => tester.pump());

        expect(find.text('Continue'), findsOneWidget);
      });
}
