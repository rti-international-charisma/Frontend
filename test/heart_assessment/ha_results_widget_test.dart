import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/heart_assessment/ha_results_page_widget.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../util/utils.dart';

void main() {
  var scoresData = {
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
      },
      {
        "sectionId": "d4dc8750-6364-4278-9c2d-2d594347cc7a",
        "sectionType": "PARTNER ABUSE AND CONTROL",
        "answers": [
          {"questionId": "e2a0f3be-c756-481e-8ac4-9be8fa515708", "score": 2},
          {"questionId": "ac4a70e8-aa40-4ffa-8769-984842d67e95", "score": 1}
        ]
      },
      {
        "sectionId": "fafcdc7a-4be6-4cf3-82e5-9ddde66479bf",
        "sectionType": "PARTNER SUPPORT",
        "answers": [
          {"questionId": "15aa0bd9-2022-406f-a6b6-8bc1d70044e7", "score": 2},
          {"questionId": "cabf12cb-4eea-484d-b6c7-f117f0550287", "score": 2}
        ]
      },
      {
        "sectionId": "b4399697-2e38-434b-9e07-94242bb91295",
        "sectionType": "PARTNER ATTITUDE TO HIV PREVENTION",
        "answers": [
          {"questionId": "b3454076-f0c7-4f8e-9f4e-89e3997ec6da", "score": 2}
        ]
      },
      {
        "sectionId": "746ad99f-0ded-4fc9-95a3-162ebe94d616",
        "sectionType": "HIV PREVENTION READINESS",
        "answers": [
          {"questionId": "bedd6c69-459d-4d4e-b017-46fab6b7c7e4", "score": 6},
          {"questionId": "916eaa5a-9431-442a-9119-1efb5375b835", "score": 6},
          {"questionId": "f8af8cb5-7707-4be3-af2a-316ac1143096", "score": 6}
        ]
      }
    ]
  };

  Map<String, dynamic> moduleData = {
    "title": "Discussing PrEP Use With Partners",
    "introduction":
        "<p>Bring about positive changes in your relationship through better communication</p>",
    "description": null,
    "summary": null,
    "heroImage": {
      "title": "PrEP Use Hero Image",
      "introduction": null,
      "summary": null,
      "imageUrl": "/assets/89390db4-434f-4d7d-92a0-152cd1368ecd"
    },
    "moduleVideo": {"videoUrl": "/assets/9fd45ac0-e7e3-4d26-b75f-62c0125bf6ec"},
    "counsellingModuleSections": [
      {
        "id": "section_4",
        "title": "How to use PrEP without anyone knowing",
        "introduction":
            "<p>Sometimes it makes sense not to tell your partner, or anyone else about your PrEP use, if you think<br />they&rsquo;ll be violent towards you or have another reaction that would be hard to handle. If you don&rsquo;t<br />want to tell them, that&rsquo;s your choice, but it&rsquo;s good to think about how to keep your PrEP use a<br />secret.</p>",
        "summary": null,
        "accordionContent": [
          {
            "id": "section_4_accordion_1",
            "description":
                "<ul>\n<li>Store pills in places your partner, or loved ones will not look, such as a handbag, a keychain with storage, or with pads and tampons.</li>\n<li>Ask a neighbour or a nearby friend to keep the pills, although this can make it challenging to remember to take them every day.</li>\n<li>Store a few doses in an unmarked container (ensure that this container is not clear plastic because sun can damage medication).</li>\n<li>If your partner or loved one monitors or watches you closely, think of a reason for the regular clinic visits. For e.g. you could tell them you&rsquo;re going to the clinic for a medical condition. You can also tell them you&rsquo;re taking this medication for another reason such as pregnancy prevention or menstrual cramps.</li>\n</ul>",
            "title": "Here are some tips that other young women have used:"
          }
        ]
      },
      {
        "id": "section_5",
        "title": "Why you decided to use oral PrEP",
        "introduction":
            "<p>If talking to a partner, the benefits for the relationship, and how PrEP will affect your sexual<br />behaviours in the relationship, and other prevention behaviours (like condom use)</p>",
        "summary": "<p>This is summary</p>"
      }
    ],
    "counsellingModuleActionPoints": [
      {
        "id": "model_prep_use_action_point_5",
        "title": "Call a PrEP clinic to ask about partner counselling"
      },
      {
        "id": "model_prep_use_action_point_6",
        "title":
            "Make a plan to keep my PrEP secret (e.g. where to store it and when to take it)"
      }
    ]
  };

  testWidgets('It displays all sections as expected when user is NOT logged in',
      (WidgetTester tester) async {
    final ApiClient apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    var results = Future<Map<String, dynamic>>.value(scoresData);
    final module = Future<Map<String, dynamic>>.value(moduleData);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    results.then(
        (value) => preferences.setString('results', convert.jsonEncode(value)));

    when(apiClient.getCounsellingModule(3, 'oppose')).thenAnswer((_) => module);

    await tester.pumpWidget(
      HAResultsPageWidget(
        apiClient: apiClient,
        assetsUrl: Utils.assetsUrl,
      ).wrapWithMaterial(),
    );
    await mockNetworkImagesFor(() => tester.pump());

    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('ScoresSection')), findsOneWidget);
    expect(find.byKey(ValueKey('UserGreeting')), findsNothing);
    expect(find.byKey(ValueKey('CounsellingModule')), findsOneWidget);
    expect(find.byKey(ValueKey('ActionPoints')), findsOneWidget);
  });

  testWidgets('It displays all sections as expected when user is logged in',
      (WidgetTester tester) async {
    final ApiClient apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    var results = Future<Map<String, dynamic>>.value(scoresData);
    var module = Future<Map<String, dynamic>>.value(moduleData);
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

    when(apiClient.getScores(userToken)).thenAnswer((_) => results);

    when(apiClient.getCounsellingModule(3, 'oppose')).thenAnswer((_) => module);

    await tester.pumpWidget(HAResultsPageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('ScoresSection')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('UserGreeting')).evaluate().single.widget as Text)
            .data,
        equals('Hey username,'));
    expect(find.byKey(ValueKey('CounsellingModule')), findsOneWidget);
    expect(find.byKey(ValueKey('ActionPoints')), findsOneWidget);
  });

  testWidgets(
      'It displays score section having title, score and explanation for every section',
      (WidgetTester tester) async {
    final ApiClient apiClient = MockApiClient();
    MockRouterDelegate routerDelegate = MockRouterDelegate();
    SharedPreferences.setMockInitialValues({});

    var results = Future<Map<String, dynamic>>.value(scoresData);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    results.then(
        (value) => preferences.setString('results', convert.jsonEncode(value)));

    await tester.pumpWidget(HAResultsPageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterialMockRouter(routerDelegate));
    await mockNetworkImagesFor(() => tester.pump());

    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('ScoresSection')), findsOneWidget);
    expect(find.byKey(ValueKey('SectionScore&Explanation')), findsNWidgets(5));

    var sectionScores = (scoresData['sections'] as List)
        .where((section) => section['sectionType'] != 'PARTNER CONTEXT')
        .toList();

    // Loop over all the sections in scores data and verify whether they are all
    // rendered correctly
    for (var index = 0; index < 5; index++) {
      var section = sectionScores[index];
      expect(
          (find.byKey(ValueKey('SectionType$index')).evaluate().single.widget
                  as Text)
              .data,
          equals(section['sectionType']));
      expect(
          (find.byKey(ValueKey('SectionScore$index')).evaluate().single.widget
                  as Text)
              .data,
          equals(
              '${getSectionScore(section['answers'])} of ${section["answers"].length * 6}'));
      expect(
          (find
                  .byKey(ValueKey('SectionExplanation$index'))
                  .evaluate()
                  .single
                  .widget as Text)
              .data,
          equals(getSectionScoreExplanation(section['sectionType'])));
    }

    // Verify the button exists,
    // with the expected text on it
    // and verify that pressing it takes you to the landing page of the test
    TextButton takeTheTestButton = find
        .byKey(ValueKey('TakeTheTestButton'))
        .evaluate()
        .single
        .widget as TextButton;

    expect(find.byKey(ValueKey('TakeTheTestButton')), findsOneWidget);
    expect(((takeTheTestButton).child as Text).data,
        equals('Take the test again'));

    takeTheTestButton.onPressed!();
    verify(routerDelegate.push(HALandingPageConfig));
  });
}

num getSectionScore(List answersList) {
  return answersList.fold(
      0, (previousValue, answer) => previousValue + answer['score']);
}

String? getSectionScoreExplanation(String sectionType) {
  switch (sectionType) {
    case 'TRADITIONAL VALUES':
      return 'Women who have higher scores on these questions generally believe men should have more power than women in family or relationship decisions.';
    case 'PARTNER ABUSE AND CONTROL':
      return 'Women who score higher on these questions generally feel their partners are more controlling or abusive than women with lower scores.';
    case 'PARTNER SUPPORT':
      return 'Women who have higher scores on these questions generally believe men should have more power than women in family or relationship decisions. ';
    case 'PARTNER ATTITUDE TO HIV PREVENTION':
      return 'Women who score higher on these questions generally feel their partners are resistant to using HIV prevention methods than women with lower scores.';
    case 'HIV PREVENTION READINESS':
      return 'Women who score higher on these questions generally feel more ready to use HIV prevention methods than women with lower scores.';
  }
}
