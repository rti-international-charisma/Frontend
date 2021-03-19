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

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../util/network_image_builder_mock.dart';

void main() {
  var contentResponse = {
    "textContent": {
      "title": "Welcome to Charisma",
      "pageid": "charisma-home",
      "contentBody": "Lorem ipsum dolor sit amet"
    },
    "assets": {
      "heroImage": [
        {
          "id": "6Od9v3wzLOysiMum0Wkmme",
          "title": "Woman with black hat",
          "url":
              "https://images.ctfassets.net/5lkmroeaw7nj/6Od9v3wzLOysiMum0Wkmme/28062c87c8e64d95e7d75791ab740c7d/cameron-kirby-88711.jpg",
          "mimeType": "image/jpeg"
        }
      ],
      "videos": [
        {
          "id": "xBarxc8wiWc2srCvoq3Si",
          "title": "file example MP4 1920 18MG",
          "url":
              "https://videos.ctfassets.net/5lkmroeaw7nj/xBarxc8wiWc2srCvoq3Si/63dab1060a7abd3d6f6f61018c51217a/file_example_MP4_1920_18MG.mp4",
          "mimeType": "video/mp4"
        },
        {
          "id": "1nxExEyhry3xV7ndhMtRVD",
          "title": "file example AVI 1920 2 3MG",
          "url":
              "https://videos.ctfassets.net/5lkmroeaw7nj/1nxExEyhry3xV7ndhMtRVD/7e69a56f87babc45e5c526ef4247ac17/file_example_AVI_1920_2_3MG.avi",
          "mimeType": "video/x-msvideo"
        },
        {
          "id": "fYSQRqjUaZ5KILfIHkDbL",
          "title": "file example OGG 1920 13 3mg",
          "url":
              "https://videos.ctfassets.net/5lkmroeaw7nj/fYSQRqjUaZ5KILfIHkDbL/6aef1473d1774964d2bb0dfac7755a10/file_example_OGG_1920_13_3mg.ogg",
          "mimeType": "video/ogg"
        }
      ]
    }
  };

  // testWidgets('It display Page title', (WidgetTester tester) async {

  //   final apiClient = MockApiClient();

  //   when(apiClient.get("/content"))
  //   .thenAnswer(
  //       (realInvocation) {
  //         return Future<Map<String, dynamic>>.value(contentResponse);
  //       }
  //   );

  //   await tester.pumpWidget(HomePageWidget(title: "Welcome to Charisma", apiClient: apiClient).wrapWithMaterial());
  //   await tester.pump();
  //   expect(find.text('Welcome to Charisma'), findsOneWidget);

  // });

  // testWidgets('It should render 2 Video Players', (WidgetTester tester) async {

  //   final apiClient = MockApiClient();
  //   when(apiClient.get("/content"))
  //       .thenAnswer(
  //           (realInvocation) {
  //         return Future<Map<String, dynamic>>.value(contentResponse);
  //       }
  //   );
  //   await tester.pumpWidget(HomePageWidget(title: "Welcome to Charisma", apiClient: apiClient).wrapWithMaterial());
  //   await tester.pump();
  //   expect(find.byType(VideoPlayerWidget), findsWidgets);

  // });
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
