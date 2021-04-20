import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/home/home_page_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../util/network_image_builder_mock.dart';

void main() {
  var data = {
    "title": "",
    "description": "",
    "introduction": "",
    "heroImage": {
      "title": "Hero Image",
      "introduction":
          "<div><span style=\"font-size: 18pt;\"><strong>Want to check the status of your relationship and protect yourself?</strong></span></div>\n<div>\n<p><span style=\"font-size: 14pt;\">CHARISMA&rsquo;s here to support you!&nbsp;</span></p>\n<p><span style=\"font-size: 14pt;\">Take a quiz about your relationship and get tailored support, or browse content on Healthy relationships, using PrEP in your relationships,&nbsp;</span><br /><span style=\"font-size: 14pt;\">good communication with your partner and others, and relationship safety. You can always come back more for later and share what you like!</span></p>\n</div>",
      "summary": "",
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
          "actionText": "Learn more",
          "actionLink": "",
          "isPrivate": false
        },
        {
          "title": "Start Here:",
          "description":
              "Take the HEART assessment test, and understand your relationship better",
          "videoUrl": "",
          "videoImage": "/assets/ea231c41-e9fc-4ea3-acba-975c659dc3df",
          "actionText": "Take the Test",
          "actionLink": "/assessment/intro",
          "isPrivate": true
        }
      ]
    },
    "steps": [
      {
        "title": "Take Relationship Quiz",
        "backgroundImageUrl": "/assets/6caced82-67c6-4434-8225-d12ad7fd1643",
        "imageUrl": "/assets/bd5c8897-fba1-4110-a3ec-cfb126526f3e"
      },
      {
        "title": "Access Counselling Content Selected Just For You",
        "backgroundImageUrl": "/assets/38f6117e-c345-49ee-8c25-e7273cde4b9a",
        "imageUrl": "/assets/fa8de294-9d7c-46b6-b933-cbe66605d31f"
      },
      {
        "title": "Share Educational Material with Partner",
        "backgroundImageUrl": "/assets/a9dd6f32-e04d-47f7-8865-8bc64ff65319",
        "imageUrl": "/assets/4bfe21df-9f30-48bc-ab96-50cf6bfc653c"
      },
      {
        "title": "Get Access To Available Support In Your Community",
        "backgroundImageUrl": "/assets/c13524f4-1b4b-4631-8779-f16026e2a4f1",
        "imageUrl": "/assets/39626393-68ef-47bc-a1b4-5c06c52fb1fa"
      }
    ]
  };

  testWidgets(
      'It displays app bar containing Charisma logo, Sign Up and Login link',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('SignUpLink')), findsOneWidget);
    expect(find.byKey(ValueKey('LoginLink')), findsOneWidget);
    expect(find.byKey(ValueKey('CharismaLogo')), findsOneWidget);
  });

  testWidgets('It displays hero image with text', (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
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

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    // Step 1
    expect(
        (find.byKey(ValueKey('Step1')).evaluate().single.widget as Text).data,
        equals('1'));
    expect(
        (find.byKey(ValueKey('Step1Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(0)['title']));

    // Step 2
    expect(
        (find.byKey(ValueKey('Step2')).evaluate().single.widget as Text).data,
        equals('2'));
    expect(
        (find.byKey(ValueKey('Step2Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(1)['title']));

    // Step 3
    expect(
        (find.byKey(ValueKey('Step3')).evaluate().single.widget as Text).data,
        equals('3'));
    expect(
        (find.byKey(ValueKey('Step3Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(2)['title']));

    // Step 4
    expect(
        (find.byKey(ValueKey('Step4')).evaluate().single.widget as Text).data,
        equals('4'));
    expect(
        (find.byKey(ValueKey('Step4Text')).evaluate().single.widget as Text)
            .data,
        equals((data['steps'] as List).elementAt(3)['title']));
  });

  testWidgets('It displays videos widget', (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('VideoSection')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoSectionHeadline')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoSectionSubHeadline')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoCarousel')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoModules')), findsNWidgets(2));
  });

  testWidgets(
      'It displays a title, a summary, a video player and an action button on each video module',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await tester.pumpWidget(HomePageWidget(
      apiClient: apiClient,
      apiBaseUrl: 'http://0.0.0.0:8080',
    ).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    var videoModule = find.byKey(ValueKey('VideoModules')).first;
    var videoHeading = find.descendant(
        of: videoModule, matching: find.byKey(ValueKey('VideoHeading1')));
    var videoSummary = find.descendant(
        of: videoModule, matching: find.byKey(ValueKey('VideoSummary1')));
    var videoPlayer = find.descendant(
        of: videoModule, matching: find.byType(VideoPlayerWidget));
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
        (videoSectionData['videos'] as List).elementAt(0)['videoUrl'];
    expect(videoPlayer, findsWidgets);
    expect((videoPlayer.evaluate().single.widget as VideoPlayerWidget).videoUrl,
        equals('http://0.0.0.0:8080$videoUrl'));
    expect(videoActionButton, findsOneWidget);
    expect(
        ((videoActionButton.evaluate().single.widget as ElevatedButton).child
                as Text)
            .data,
        (videoSectionData['videos'] as List).elementAt(0)['actionText']);
  });

  testWidgets('It displays links to other pages', (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/home")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(data);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(
        (find.byKey(ValueKey('HomePageLink0')).evaluate().single.widget as Text)
            .data,
        equals('HIV Prevention: PrEP'));

    expect(
        (find.byKey(ValueKey('HomePageLink1')).evaluate().single.widget as Text)
            .data,
        equals('Male Partner Information Pack'));

    expect(
        (find.byKey(ValueKey('HomePageLink2')).evaluate().single.widget as Text)
            .data,
        equals('Referrals'));

    expect(
        (find.byKey(ValueKey('HomePageLink3')).evaluate().single.widget as Text)
            .data,
        equals('Take the HEART assessment test'));

    expect(
        (find.byKey(ValueKey('HomePageLink4')).evaluate().single.widget as Text)
            .data,
        equals('Counselling Content'));

    expect(
        (find.byKey(ValueKey('HomePageLink5')).evaluate().single.widget as Text)
            .data,
        equals('About Us'));
  });
}

class MockApiClient extends Mock implements ApiClient {}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (ctx) => MockNetworkImageBuilder()),
          InheritedProvider<CharismaRouterDelegate>(
              create: (ctx) => CharismaRouterDelegate(MockApiClient()))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: this,
        )),
      );
}
