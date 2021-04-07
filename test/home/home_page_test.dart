// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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
  var contentResponse = {
    "data": {
      "id": "homepage",
      "status": "published",
      "video_section": {
        "id": "video_section",
        "status": "published",
        "headline": "Build a healthy relationship with your partner",
        "sub_headline":
            "Here are some videos, activities and reading material for you",
        "videos": [
          {
            "id": "homepage_video",
            "status": "published",
            "videofile": "f5930b41-f299-4728-b035-919156a06675",
            "actiontext": "Learn More",
            "title": "How’s the health of your relationship?",
            "description":
                "All relationships have challenges, but it’s important to know what’s healthy or not. Read more to learn about healthy and unhealthy relationship qualities. It requires you to reflect on your own relationships using what you have learned.",
            "module_image": null,
            "video_section": "video_section"
          },
          {
            "id": "video_module2",
            "status": "published",
            "videofile": "9fd45ac0-e7e3-4d26-b75f-62c0125bf6ec",
            "actiontext": "Learn More",
            "title": "Do you know the different ways of communicating?",
            "description":
                "Communication is more than just the words you speak. Often we are not “heard” because we struggle to separate our feelings from facts when we’re upset. This section will give you skills to communicate better with your partner and use conflict to actually get what you both want and need in your relationship.",
            "module_image": null,
            "video_section": "video_section"
          },
          {
            "id": "video_module3",
            "status": "published",
            "videofile": "2b22ad56-c682-4167-817b-e8c55aff51e0",
            "actiontext": "Learn More",
            "title": "Discussing PrEP Use with Partners",
            "description":
                "Are you on PrEP or would like to be on PrEP but don’t know how to tell your partner about it? We’ve got you. Read more to learn about ways other women tell their male partners. And if you’re not ready you can also learn how to use PrEP without telling your partner.",
            "module_image": null,
            "video_section": "video_section"
          },
          {
            "id": "video_module4",
            "status": "published",
            "videofile": null,
            "actiontext": "Learn More",
            "title": "Staying safe in a violent relationship",
            "description":
                "Tension and conflict is common in relationships, but it should not lead to physical abuse. Are you aware that abuse is not only physical? Read more to find out what you can do if you suspect you are in an abusive relationship. It’s good to have a back-up plan to make sure you stay safe even if you’re not ready to seek help.",
            "module_image": "b2974a8b-0b59-47da-9538-466cf4d0307f",
            "video_section": "video_section"
          }
        ]
      },
      "charisma_steps": [
        {
          "id": 1,
          "text": "Login",
          "number_background_image": {
            "id": "a1152951-3280-4725-9ff2-bc0d4b66b9be"
          },
          "number_image": {"id": "09141bd8-7008-4f81-8fc3-5f20dea47c2e"},
          "sub_text": null
        },
        {
          "id": 2,
          "text": "Take the test",
          "number_background_image": {
            "id": "1a8ccc34-9b0d-4fd7-9a37-95688b768e4b"
          },
          "number_image": {"id": "b4b8343d-c967-4c66-bebd-60d6a16e2d53"},
          "sub_text": null
        },
        {
          "id": 3,
          "text": "Complete a Charisma recommended module",
          "number_background_image": {
            "id": "56cc6703-0099-42c5-b3fd-d401b99235a5"
          },
          "number_image": {"id": "60034689-1340-4684-acad-7ab3cafa985d"},
          "sub_text": null
        },
        {
          "id": 4,
          "text": "Get professional help",
          "number_background_image": {
            "id": "4bb2c9ee-1922-4d76-9e83-6477f6f13b57"
          },
          "number_image": {"id": "de72b5a9-0981-47c1-9818-1d446530f9c6"},
          "sub_text": "Legal, relationship, mental health"
        }
      ],
      "hero_image": [
        {
          "id": 1,
          "image": {"id": "f55512a0-a3bc-45f9-85ca-8f19fa7bd2bf"},
          "text":
              "<div><strong><span style=\"font-size: 14pt;\">Want to check the status of your relationship and protect yourself?</span></strong></div>\n<div>&nbsp;</div>\n<div>\n<p>CHARISMA&rsquo;s here to support you!&nbsp;</p>\n<p>Take a quiz about your relationship and get tailored support, or browse content on Healthy relationships, using PrEP in your relationships,&nbsp;<br />good communication with your partner and others, and relationship safety.</p>\n</div>",
        }
      ]
    }
  };

  testWidgets('It displays app bar containing Charisma logo and Login link',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/homepage")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(contentResponse);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());
    expect(find.byKey(ValueKey('LoginLink')), findsOneWidget);
    expect(find.byKey(ValueKey('CharismaLogo')), findsOneWidget);
  });

  testWidgets('It displays hero image with text', (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/homepage")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(contentResponse);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());
    expect(find.byKey(ValueKey('HeroImage')), findsOneWidget);

    var heroImageText =
        find.byKey(ValueKey('HeroImageText')).evaluate().single.widget as Html;
    expect(find.byKey(ValueKey('HeroImageText')), findsOneWidget);
    expect(
        heroImageText.data,
        equals((contentResponse['data']!['hero_image'] as List)
            .elementAt(0)['text']));
  });

  testWidgets('It displays different steps for how Charisma works',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/homepage")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(contentResponse);
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
        equals('Login'));

    // Step 2
    expect(
        (find.byKey(ValueKey('Step2')).evaluate().single.widget as Text).data,
        equals('2'));
    expect(
        (find.byKey(ValueKey('Step2Text')).evaluate().single.widget as Text)
            .data,
        equals('Take the test'));

    // Step 3
    expect(
        (find.byKey(ValueKey('Step3')).evaluate().single.widget as Text).data,
        equals('3'));
    expect(
        (find.byKey(ValueKey('Step3Text')).evaluate().single.widget as Text)
            .data,
        equals('Complete a Charisma recommended module'));

    // Step 4
    expect(
        (find.byKey(ValueKey('Step4')).evaluate().single.widget as Text).data,
        equals('4'));
    expect(
        (find.byKey(ValueKey('Step4Text')).evaluate().single.widget as Text)
            .data,
        equals('Get professional help'));
    expect(
        (find.byKey(ValueKey('Step4SubText')).evaluate().single.widget as Text)
            .data,
        equals('Legal, relationship, mental health'));
  });

  testWidgets('It displays videos widget', (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/homepage")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(contentResponse);
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

    when(apiClient.get("/homepage")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(contentResponse);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
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

    var videoSectionData =
        contentResponse['data']!['video_section'] as Map<String, dynamic>;

    expect(videoHeading, findsOneWidget);
    expect((videoHeading.evaluate().single.widget as Text).data,
        equals((videoSectionData['videos'] as List).elementAt(0)['title']));

    expect(videoSummary, findsOneWidget);
    expect(
        (videoSummary.evaluate().single.widget as Text).data,
        equals(
            (videoSectionData['videos'] as List).elementAt(0)['description']));

    String videoUrl =
        (videoSectionData['videos'] as List).elementAt(0)['videofile'];
    expect(videoPlayer, findsWidgets);
    expect((videoPlayer.evaluate().single.widget as VideoPlayerWidget).videoUrl,
        equals('http://0.0.0.0:8080/assets/$videoUrl'));
    expect(videoActionButton, findsOneWidget);
    expect(
        ((videoActionButton.evaluate().single.widget as ElevatedButton).child
                as Text)
            .data,
        (videoSectionData['videos'] as List).elementAt(0)['actiontext']);
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
