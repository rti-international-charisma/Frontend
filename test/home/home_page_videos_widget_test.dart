import 'package:carousel_slider/carousel_slider.dart';

import 'package:charisma/home/home_page_videos_widget.dart';
import 'package:charisma/navigation/charisma_parser.dart';
import 'package:charisma/navigation/ui_pages.dart';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:mockito/mockito.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/utils.dart';

void main() {
  var data = {
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
          "actionLink": "/module/prep_use",
          "isPrivate": false
        },
        {
          "title": "Do you know the different ways of communicating?",
          "description":
              "Communication is more than just the words you speak. Often we are not “heard” because we struggle to separate our feelings from facts when we’re upset. This section will give you skills to communicate better with your partner and use conflict to actually get what you both want and need in your relationship.",
          "videoUrl": "/assets/9fd45ac0-e7e3-4d26-b75f-62c0125bf6ec",
          "videoImage": "",
          "actionText": "Learn more",
          "actionLink": "/module/partner_comm",
          "isPrivate": false
        },
        {
          "title": "Discussing PrEP Use with Partners",
          "description":
              "Are you on PrEP or would like to be on PrEP but don’t know how to tell your partner about it? We’ve got you. Read more to learn about ways other women tell their male partners. And if you’re not ready you can also learn how to use PrEP without telling your partner.",
          "videoUrl": "/assets/2b22ad56-c682-4167-817b-e8c55aff51e0",
          "videoImage": "",
          "actionText": "Learn more",
          "actionLink": "/module/prep_use",
          "isPrivate": false
        },
        {
          "title": "Staying safe in a violent relationship",
          "description":
              "Tension and conflict is common in relationships, but it should not lead to physical abuse. Are you aware that abuse is not only physical? Read more to find out what you can do if you suspect you are in an abusive relationship. It’s good to have a back-up plan to make sure you stay safe even if you’re not ready to seek help.",
          "videoUrl": "",
          "videoImage": "/assets/f9b06145-94c3-4a7f-835a-1300cbf599c4",
          "actionText": "Learn more",
          "actionLink": "/module/ipv",
          "isPrivate": false
        },
        {
          "title": "Start Here:",
          "description":
              "Take the HEART assessment, and understand your relationship better",
          "videoUrl": "",
          "videoImage": "/assets/ea231c41-e9fc-4ea3-acba-975c659dc3df",
          "actionText": "Take the Assessment",
          "actionLink": "/assessment/intro",
          "isPrivate": true
        }
      ]
    }
  };

  testWidgets(
      'It displays videos widget, showing only public videos when user is not signed in',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(HomePageVideos(
          data: data['videoSection'],
          assetsUrl: Utils.assetsUrl,
          isLoggedIn: false,
        ).wrapWithMaterial()));

    expect(find.byKey(ValueKey('VideoSection')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoSectionHeadline')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoSectionSubHeadline')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoCarousel')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoModules')), findsNWidgets(2));
    expect(
        (find.byKey(ValueKey('VideoCarousel')).evaluate().single.widget
                as CarouselSlider)
            .itemCount,
        equals(4)); // One video is not shown because it is private

    var videoModule = find.byKey(ValueKey('VideoModules')).first;
    var videoHeading = find.descendant(
        of: videoModule, matching: find.byKey(ValueKey('VideoHeading1')));
    var videoSectionData = data['videoSection'] as Map<String, dynamic>;

    // here the first video shown has the 'isPrivate' flag set to false
    expect((videoHeading.evaluate().single.widget as Text).data,
        equals((videoSectionData['videos'] as List).elementAt(0)['title']));
  });

  testWidgets(
      'It displays videos widget, showing both private & public videos when user is signed in',
      (WidgetTester tester) async {
    final sharedPreferenceHelper = MockSharedPreferencesHelper();

    SharedPreferences.setMockInitialValues({});

    var userData = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": "some.jwt.token"
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    userData.then((value) =>
        preferences.setString('userData', convert.jsonEncode(value)));

    when(sharedPreferenceHelper.getUserData()).thenAnswer((_) => userData);

    await mockNetworkImagesFor(() => tester.pumpWidget(HomePageVideos(
          data: data['videoSection'],
          assetsUrl: Utils.assetsUrl,
          isLoggedIn: true,
        ).wrapWithMaterial()));

    expect(find.byKey(ValueKey('VideoSection')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoSectionHeadline')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoSectionSubHeadline')), findsOneWidget);
    expect(find.byKey(ValueKey('VideoCarousel')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('VideoCarousel')).evaluate().single.widget
                as CarouselSlider)
            .itemCount,
        equals(5)); // All 5 videos are shown because the user is signed in
    expect(find.byKey(ValueKey('VideoModules')), findsNWidgets(2));

    var videoModule = find.byKey(ValueKey('VideoModules')).first;
    var videoHeading = find.descendant(
        of: videoModule, matching: find.byKey(ValueKey('VideoHeading1')));
    var videoSectionData = data['videoSection'] as Map<String, dynamic>;

    // here the first video shown is from the data which has the 'isPrivate' flag set to true
    expect((videoHeading.evaluate().single.widget as Text).data,
        equals((videoSectionData['videos'] as List).elementAt(4)['title']));

    // Resetting this data so that it doesn't interfere with other tests below
    preferences.setString('userData', '');
  });

  testWidgets(
      'It navigates to the correct page based on the actionLink field used on the action button on videos',
      (WidgetTester tester) async {
    MockRouterDelegate routerDelegate = MockRouterDelegate();
    final CharismaParser _parser = CharismaParser();
    final sharedPreferenceHelper = MockSharedPreferencesHelper();

    SharedPreferences.setMockInitialValues({});

    var userData = Future<Map<String, dynamic>>.value({
      "user": {
        "id": 1,
        "username": "username",
        "sec_q_id": 1,
        "loginAttemptsLeft": 5
      },
      "token": "some.jwt.token"
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    userData.then((value) =>
        preferences.setString('userData', convert.jsonEncode(value)));

    when(sharedPreferenceHelper.getUserData()).thenAnswer((_) => userData);

    await tester.pumpWidget(HomePageVideos(
      data: data['videoSection'],
      assetsUrl: Utils.assetsUrl,
      isLoggedIn: true,
    ).wrapWithMaterialMockRouter(routerDelegate));
    await mockNetworkImagesFor(() => tester.pump());

    var videoSectionData = data['videoSection'] as Map<String, dynamic>;
    var videos = videoSectionData['videos'];
    List privateVideos =
        (videos as List).where((video) => video['isPrivate']).toList();

    List publicVideos = videos.where((video) => !video['isPrivate']).toList();

    videos = privateVideos + publicVideos;

    for (var index = 0; index < videos.length; index++) {
      var videoData = videos[index] as Map<String, dynamic>;

      Future<PageConfiguration> pageConfigFuture =
          _parser.parseRouteInformation(
              RouteInformation(location: videoData['actionLink']));

      await tester
          .ensureVisible(find.byKey(ValueKey('VideoActionButton$index')));
      ElevatedButton videoActionButton = find
          .byKey(ValueKey('VideoActionButton$index'))
          .evaluate()
          .single
          .widget as ElevatedButton;
      videoActionButton.onPressed!();

      await tester.pump(Duration.zero);
      pageConfigFuture.then((pageConfig) {
        verify(routerDelegate.push(pageConfig));
      });
    }
  });
}
