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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../util/network_image_builder_mock.dart';

void main() {
  var contentResponse = {
    "textContent": {
      "videoSummary1":
          "All relationships have challenges, but it’s important to know what’s healthy or not. Read more to learn about healthy and unhealthy relationship qualities. It requires you to reflect on your own relationships using what you have learned.",
      "videoSummary2":
          "Communication is more than just the words you speak. Often we are not “heard” because we struggle to separate our feelings from facts when we’re upset. This section will give you skills to communicate better with your partner and use conflict to actually get what you both want and need in your relationship.",
      "video1Link":
          "https://drive.google.com/file/d/1SC3uUnbNLqIjPpwVCXzvob3E7NDGM6Bi/view?usp=sharing",
      "howCharismaWorks": "How Charisma works...",
      "title": "Welcome to Charisma",
      "pageid": "charisma-home",
      "videoSummary3":
          "Are you on PrEP or would like to be on PrEP but don’t know how to tell your partner about it? We’ve got you. Read more to learn about ways other women tell their male partners. And if you’re not ready you can also learn how to use PrEP without telling your partner. ",
      "videoSummary4":
          "Tension and conflict is common in relationships, but it should not lead to physical abuse. Are you aware that abuse is not only physical? Read more to find out what you can do if you suspect you are in an abusive relationship. It’s good to have a back-up plan to make sure you stay safe even if you’re not ready to seek help. ",
      "heroImageText":
          "Want to check the status of your relationship and protect yourself?\n\nCHARISMA’s here to support you! \n\nTake a quiz about your relationship and get tailored support, or browse content on Healthy relationships, using PrEP in your relationships, \ngood communication with your partner and others, and relationship safety.",
      "videoSectionSubHeadline":
          "Here are some videos, activities and reading material for you",
      "video3Link":
          "https://drive.google.com/file/d/1Nfguavz85EMcapPm6wujWlfN6KDs902o/view?usp=sharing",
      "step4": "Get professional help",
      "videoSectionHeadline": "Build a healthy relationship with your partner",
      "videoHeading1": "How’s the health of your relationship?",
      "step4SubText": "Legal, relationship, mental health",
      "videoHeading2": "Do you know the different ways of communicating?",
      "step2": "Take the test",
      "videoHeading3": "Discussing PrEP Use with Partners",
      "step3": "Complete a Charisma recommended module",
      "videoHeading4": "Staying safe in a violent relationship",
      "step1": "Login",
      "video2Link":
          "https://drive.google.com/file/d/1qNc_sIdo71N6TpRewlYqOSPd6dA6bBBz/view?usp=sharing"
    },
    "assets": {
      "heroImage": [
        {
          "id": "1f7kiLqtEFWjDk7Nv7naYj",
          "title": "Smiling woman",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/1f7kiLqtEFWjDk7Nv7naYj/d9bb5c622e08530ba6917a54bd84a6d0/image_9.png",
          "mimeType": "image/png"
        }
      ],
      "videos": [
        {
          "id": "53HE5PKJqQNSvTvBD9zN1P",
          "title": "file example MP4 1920 18MG",
          "url":
              "https://videos.ctfassets.net/5lkmroeaw7nj/53HE5PKJqQNSvTvBD9zN1P/e7b08af41183cc2ba08b146e288459be/file_example_MP4_1920_18MG.mp4",
          "mimeType": "video/mp4"
        }
      ],
      "stepImage": [
        {
          "id": "39rujUK4OFzXo3zUXnCNiP",
          "title": "step 1 image",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/39rujUK4OFzXo3zUXnCNiP/1fa4f4d1e4ba376bacc3a57fea42d424/Ellipse_3.png",
          "mimeType": "image/png"
        },
        {
          "id": "2m68xuxcWL2z1MryrI82TE",
          "title": "step 1 background image",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/2m68xuxcWL2z1MryrI82TE/ba4c1cfe48131e7e47f5960ac37dfec6/Ellipse_9.png",
          "mimeType": "image/png"
        },
        {
          "id": "3SusdltSbDhoeLSnzM24xs",
          "title": "step 2 image",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/3SusdltSbDhoeLSnzM24xs/00ec37a4de94ffe2bac1e4fe82f4759f/Ellipse_10.png",
          "mimeType": "image/png"
        },
        {
          "id": "6YKlg7YgKnTSRz0GjE0Apg",
          "title": "step 2 background image",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/6YKlg7YgKnTSRz0GjE0Apg/f2a8abf98812247db1cd5708364efc8e/Ellipse_4.png",
          "mimeType": "image/png"
        },
        {
          "id": "35avwgnlmJg5QN3ixJf10n",
          "title": "step 3 image ",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/35avwgnlmJg5QN3ixJf10n/c59485312e9dadd8707d4c5ddd43683e/Ellipse_11.png",
          "mimeType": "image/png"
        },
        {
          "id": "7oFnb4n29KmXZ9bYeqmRCL",
          "title": "step 3 background image",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/7oFnb4n29KmXZ9bYeqmRCL/ddf11c551a718069afb5d2a5c876c6e8/Ellipse_6.png",
          "mimeType": "image/png"
        },
        {
          "id": "2Yh4jH8jjQLRlELXDlJoRq",
          "title": "step 4 image",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/2Yh4jH8jjQLRlELXDlJoRq/feb5dceb399304463668a068384988f1/Ellipse_12.png",
          "mimeType": "image/png"
        },
        {
          "id": "2fthTuKshd2AYLvziG4Pbz",
          "title": "step 4 background image",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/2fthTuKshd2AYLvziG4Pbz/34a95c1feee5a54b144773207ac2e638/Ellipse_7.png",
          "mimeType": "image/png"
        }
      ]
    }
  };

  testWidgets('It displays app bar containing Charisma logo and Login link',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/content")).thenAnswer((realInvocation) {
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

    when(apiClient.get("/content")).thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(contentResponse);
    });

    await tester
        .pumpWidget(HomePageWidget(apiClient: apiClient).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());
    expect(find.byKey(ValueKey('HeroImage')), findsOneWidget);

    var heroImageText =
        find.byKey(ValueKey('HeroImageText')).evaluate().single.widget as Text;
    expect(find.byKey(ValueKey('HeroImageText')), findsOneWidget);
    expect(heroImageText.data,
        equals(contentResponse['textContent']!['heroImageText']));
  });

  testWidgets('It displays different steps for how Charisma works',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/content")).thenAnswer((realInvocation) {
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

    when(apiClient.get("/content")).thenAnswer((realInvocation) {
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
      'It displays a title, a summary and a video player on each video module',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/content")).thenAnswer((realInvocation) {
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

    expect(videoHeading, findsOneWidget);
    expect((videoHeading.evaluate().single.widget as Text).data,
        equals(contentResponse['textContent']!['videoHeading1']));

    expect(videoSummary, findsOneWidget);
    expect((videoSummary.evaluate().single.widget as Text).data,
        equals(contentResponse['textContent']!['videoSummary1']));
    expect(videoPlayer, findsWidgets);
    expect(
        (videoPlayer.evaluate().single.widget as VideoPlayerWidget).videoUrl,
        equals((contentResponse['assets']!['videos'] as List)
            .elementAt(0)['url']));
  });
}

class MockApiClient extends Mock implements ApiClient {}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (ctx) => MockNetworkImageBuilder())
        ],
        child: MaterialApp(
            home: Scaffold(
          body: this,
        )),
      );
}
