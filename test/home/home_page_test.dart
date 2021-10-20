import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/common/youtube_player_widget.dart';
import 'package:charisma/home/home_page_widget.dart';
import 'package:charisma/home/partial_assessment_progress_widget.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'dart:convert' as convert;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/utils.dart';

void main() {
  var data = {
    "title": "",
    "description": "",
    "introduction": "",
    "heroImageCaptionTestComplete":
        "<p><span style=\"font-size: 14pt;\">Well done on completing assessment! You can check your scores again below and continue reading the counselling content suggested for you.</span></p>",
    "heroImageCaptionTestIncomplete":
        "<p><span style=\"font-size: 14pt;\">You&rsquo;ve been doing so well and we want to help you to keep up the progress.</span></p>",
    "heroImage": {
      "title": "Hero Image",
      "introduction":
          "<div><span style=\"font-size: 18pt;\"><strong>Want to check the status of your relationship and protect yourself?</strong></span></div>\n<div>\n<p><span style=\"font-size: 14pt;\">CHARISMA&rsquo;s here to support you!&nbsp;</span></p>\n<p><span style=\"font-size: 14pt;\">Take a quiz about your relationship and get tailored support, or browse content on Healthy relationships, using PrEP in your relationships,&nbsp;</span><br /><span style=\"font-size: 14pt;\">good communication with your partner and others, and relationship safety. You can always come back more for later and share what you like!</span></p>\n</div>",
      "imageUrl": "/assets/82c667f6-c82e-4c89-a8f0-e715563f87dc"
    },
    "images": [],
    "videoSection": {
      "introduction": "Build a healthy relationship with your partner",
      "summary":
          "Here are some videos, activities and reading material for you",
      "videos": [
        {
          "title": "How's the health of your relationship?",
          "description":
              "All relationships have challenges, but it’s important to know what’s healthy or not. Read more to learn about healthy and unhealthy relationship qualities. It requires you to reflect on your own relationships using what you have learned.",
          "videoUrl": "/assets/f5930b41-f299-4728-b035-919156a06675",
          "youtubeVideoUrl": "https://www.youtube.com/watch?v=JnxzZWaJB_E",
          "videoImage": "",
          "actionText": "Learn more",
          "actionLink": "",
          "isPrivate": false
        },
        {
          "title": "Do you know the different ways of communicating?",
          "description":
              "Communication is more than just the words you speak. Often we are not “heard” because we struggle to separate our feelings from facts when we’re upset. This section will give you skills to communicate better with your partner and use conflict to actually get what you both want and need in your relationship.",
          "videoUrl": "/assets/9fd45ac0-e7e3-4d26-b75f-62c0125bf6ec",
          "youtubeVideoUrl": "https://www.youtube.com/watch?v=k3IvJVc_asI",
          "videoImage": "",
          "actionText": "Learn more",
          "actionLink": "",
          "isPrivate": false
        },
        {
          "title": "Discussing PrEP Use with Partners",
          "description":
              "Are you on PrEP or would like to be on PrEP but don’t know how to tell your partner about it? We’ve got you. Read more to learn about ways other women tell their male partners. And if you’re not ready you can also learn how to use PrEP without telling your partner.",
          "videoUrl": "/assets/2b22ad56-c682-4167-817b-e8c55aff51e0",
          "youtubeVideoUrl": "https://www.youtube.com/watch?v=_QwXO1ChVPc",
          "videoImage": "",
          "actionText": "Learn more",
          "actionLink": "",
          "isPrivate": false
        },
        {
          "title": "Staying safe in a violent relationship",
          "description":
              "Tension and conflict is common in relationships, but it should not lead to physical abuse. Are you aware that abuse is not only physical? Read more to find out what you can do if you suspect you are in an abusive relationship. It’s good to have a back-up plan to make sure you stay safe even if you’re not ready to seek help.",
          "videoUrl": "",
          "videoImage": "/assets/f9b06145-94c3-4a7f-835a-1300cbf599c4",
          "youtubeVideoUrl": null,
          "actionText": "Learn more",
          "actionLink": "",
          "isPrivate": false
        },
        {
          "title": "Start Here:",
          "description":
              "Take the HEART assessment, and understand your relationship better",
          "videoUrl": "",
          "youtubeVideoUrl": null,
          "videoImage": "/assets/ea231c41-e9fc-4ea3-acba-975c659dc3df",
          "actionText": "Take the Assessment",
          "actionLink": "/assessment/intro",
          "isPrivate": true
        }
      ]
    },
    "steps": [
      {
        "title": "Take Relationship Quiz",
        "stepNumber": 1,
        "backgroundImageUrl": "/assets/6caced82-67c6-4434-8225-d12ad7fd1643",
        "imageUrl": "/assets/bd5c8897-fba1-4110-a3ec-cfb126526f3e"
      },
      {
        "title": "Get Access To Available Support In Your Community",
        "stepNumber": 4,
        "backgroundImageUrl": "/assets/c13524f4-1b4b-4631-8779-f16026e2a4f1",
        "imageUrl": "/assets/39626393-68ef-47bc-a1b4-5c06c52fb1fa"
      },
      {
        "title": "Access Counselling Content Selected Just For You",
        "stepNumber": 2,
        "backgroundImageUrl": "/assets/38f6117e-c345-49ee-8c25-e7273cde4b9a",
        "imageUrl": "/assets/fa8de294-9d7c-46b6-b933-cbe66605d31f"
      },
      {
        "title": "Share Educational Material with Partner",
        "stepNumber": 3,
        "backgroundImageUrl": "/assets/a9dd6f32-e04d-47f7-8865-8bc64ff65319",
        "imageUrl": "/assets/4bfe21df-9f30-48bc-ab96-50cf6bfc653c"
      }
    ]
  };

  var completedAssessmentScoresData = {
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
    ],
    "totalSections": 6
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

  testWidgets('It displays hero image with text', (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/home")).thenAnswer((_) {
      return Future<Map<String, dynamic>>.value(data);
    });

    var userStateModel = UserStateModel();
    userStateModel.userLoggedOut();

    await tester.pumpWidget(HomePageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterialAndUserState(userStateModel));

    await mockNetworkImagesFor(() => tester.pump());
    expect(find.byKey(ValueKey('HeroImage')), findsOneWidget);

    var heroImageText =
        find.byKey(ValueKey('HeroImageText')).evaluate().single.widget as Html;
    expect(find.byKey(ValueKey('HeroImageText')), findsOneWidget);
    expect(heroImageText.data,
        equals((data['heroImage'] as Map<String, dynamic>)['introduction']));
  });

  testWidgets('It displays different steps for how Charisma works',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/home")).thenAnswer((_) {
      return Future<Map<String, dynamic>>.value(data);
    });

    var userStateModel = UserStateModel();
    userStateModel.userLoggedOut();

    await tester.pumpWidget(HomePageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterialAndUserState(userStateModel));

    await mockNetworkImagesFor(() => tester.pump());

    // Step 1
    expect(
        (find.byKey(ValueKey('StepNumber1')).evaluate().single.widget as Text)
            .data,
        equals('1'));
    expect(
        (find.byKey(ValueKey('Step1Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(0)['title']));

    // Step 2
    expect(
        (find.byKey(ValueKey('StepNumber2')).evaluate().single.widget as Text)
            .data,
        equals('2'));
    expect(
        (find.byKey(ValueKey('Step2Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(1)['title']));

    // Step 3
    expect(
        (find.byKey(ValueKey('StepNumber3')).evaluate().single.widget as Text)
            .data,
        equals('3'));
    expect(
        (find.byKey(ValueKey('Step3Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(2)['title']));

    // Step 4
    expect(
        (find.byKey(ValueKey('StepNumber4')).evaluate().single.widget as Text)
            .data,
        equals('4'));
    expect(
        (find.byKey(ValueKey('Step4Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(3)['title']));
  });

  testWidgets('Tapping on the various steps takes you to the relevant page',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    MockRouterDelegate routerDelegate = MockRouterDelegate();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/home")).thenAnswer((_) {
      return Future<Map<String, dynamic>>.value(data);
    });

    var userStateModel = UserStateModel();
    userStateModel.userLoggedOut();

    await tester.pumpWidget(HomePageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterialMockRouterUserState(routerDelegate, userStateModel));

    await mockNetworkImagesFor(() => tester.pump());

    // Step 1
    await tester.ensureVisible(find.byKey(ValueKey('Step1')));
    await tester.tap(find.byKey(ValueKey('Step1')));
    verify(routerDelegate.replace(HALandingPageConfig));

    // Step 2
    // Test for this one is not needed as we simply scroll the homepage
    // to the bottom to make the Counselling Content footer link visible.

    // Step 3
    await tester.tap(find.byKey(ValueKey('Step3')));
    verify(routerDelegate.replace(MalePartnerInfoConfig));

    // Step 4
    await tester.tap(find.byKey(ValueKey('Step4')));
    verify(routerDelegate.replace(ReferralsConfig));
  });

  testWidgets(
      'It displays a title, a summary, a video player and an action button on each video module',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await mockNetworkImagesFor(() => tester.pumpWidget(HomePageWidget(
          apiClient: apiClient,
          assetsUrl: Utils.assetsUrl,
        ).wrapWithMaterial()));
    await mockNetworkImagesFor(() => tester.pump());
    await tester.pump(Duration.zero);

    var videoModule = find.byKey(ValueKey('VideoModules')).first;
    var videoHeading = find.descendant(
        of: videoModule, matching: find.byKey(ValueKey('VideoHeading How\'s the health of your relationship?')));
    var videoSummary = find.descendant(
        of: videoModule, matching: find.byKey(ValueKey('VideoSummary How\'s the health of your relationship?')));
    var videoPlayer = find.descendant(
        of: videoModule, matching: find.byType(YoutubePlayerWidget));
    var videoActionButton =
        find.descendant(of: videoModule, matching: find.byType(ElevatedButton));

    var videoSectionData = data['videoSection'] as Map<String, dynamic>;

    expect(videoHeading, findsOneWidget);
    expect((videoHeading.evaluate().single.widget as Text).data,
        equals((videoSectionData['videos'] as List).elementAt(0)['title']));

    expect(videoSummary, findsOneWidget);
    expect(
        (videoSummary.evaluate().single.widget as Text).data,
        equals(
            (videoSectionData['videos'] as List).elementAt(0)['description']));

    String videoUrl =
        (videoSectionData['videos'] as List).elementAt(0)['youtubeVideoUrl'];
    expect(videoPlayer, findsWidgets);
    // expect((videoPlayer.evaluate().single.widget as YoutubePlayerWidget).videoUrl,
    //     equals('${Utils.assetsUrl}$videoUrl'));
    expect(videoActionButton, findsOneWidget);
    expect(
        ((videoActionButton.evaluate().single.widget as ElevatedButton).child
                as Text)
            .data,
        (videoSectionData['videos'] as List).elementAt(0)['actionText']);
  });

  testWidgets('It displays app bar & footer links',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await tester.pumpWidget(HomePageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterial());

    await mockNetworkImagesFor(() => tester.pump());
    await tester.pump();

    expect(find.byKey(ValueKey('CharismaAppBar')), findsOneWidget);
    expect(find.byKey(ValueKey('CharismaFooterLinks')), findsOneWidget);
  });

  testWidgets(
      'It displays hero image, scores and counselling module to a logged in user if he has completed the assessment',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    var results =
        Future<Map<String, dynamic>>.value(completedAssessmentScoresData);
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

    when(apiClient.get('/home'))
        .thenAnswer((_) => Future<Map<String, dynamic>>.value(data));

    when(apiClient.getCounsellingModule(3, 'oppose')).thenAnswer((_) => module);

    var userStateModel = UserStateModel();
    userStateModel.userLoggedIn();
    await tester.pumpWidget(HomePageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterialAndUserState(userStateModel));
    await tester.pump(Duration.zero);
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HeroImage')), findsOneWidget);

    var heroImageText =
        find.byKey(ValueKey('HeroImageText')).evaluate().single.widget as Html;
    expect(find.byKey(ValueKey('HeroImageText')), findsOneWidget);
    expect(heroImageText.data, contains('Welcome back, username!'));
    expect(heroImageText.data, contains(data['heroImageCaptionTestComplete']));
    expect(find.byKey(ValueKey('ScoresSection')), findsOneWidget);

    await tester.pump(Duration.zero);
    expect(find.byKey(ValueKey('CounsellingModule')), findsOneWidget);

    expect(find.byKey(ValueKey('CharismaSteps')), findsNothing);
    expect(find.byKey(ValueKey('VideoModules')), findsNothing);
    expect(find.byType(PartialAssessmentProgressWidget), findsNothing);
    expect(find.byKey(ValueKey('CharismaFooterLinks')), findsOneWidget);
  });

  testWidgets(
      'it displays  assessment progressbar if assessment is partially completed',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({});

    var results = Future<Map<String, dynamic>>.value(
        partiallyCompletedAssessmentScoresData);

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

    when(apiClient.get('/home'))
        .thenAnswer((_) => Future<Map<String, dynamic>>.value(data));

    var userStateModel = UserStateModel();
    userStateModel.userLoggedIn();
    await tester.pumpWidget(HomePageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterialAndUserState(userStateModel));
    await tester.pump(Duration.zero);
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byType(PartialAssessmentProgressWidget), findsOneWidget);
    expect(find.byKey(ValueKey('HeroImage')), findsOneWidget);

    var heroImageText =
        find.byKey(ValueKey('HeroImageText')).evaluate().single.widget as Html;
    expect(find.byKey(ValueKey('HeroImageText')), findsOneWidget);
    expect(heroImageText.data, contains('Welcome back, username!'));
    expect(
        heroImageText.data, contains(data['heroImageCaptionTestIncomplete']));

    expect(find.byKey(ValueKey('CharismaSteps')), findsNothing);
  });
}
