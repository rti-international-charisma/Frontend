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
  testWidgets('It display Page title', (WidgetTester tester) async {

    final apiClient = MockApiClient();
    await tester.pumpWidget(HomePageWidget(title: "Welcome to Charisma", apiClient: apiClient).wrapWithMaterial());

    expect(find.text('Welcome to Charisma'), findsOneWidget);

  });

  testWidgets('It should render 2 Video Players', (WidgetTester tester) async {

    final apiClient = MockApiClient();
    await tester.pumpWidget(HomePageWidget(title: "Welcome to Charisma", apiClient: apiClient).wrapWithMaterial());

    expect(find.byType(VideoPlayerWidget), findsNWidgets(2));

  });
}

class MockApiClient extends Mock implements ApiClient{}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
    providers: [
      Provider<NetworkImageBuilder>(create: (ctx) => MockNetworkImageBuilder())
    ],
    child: MaterialApp(
        home: Scaffold(
          body: this,
        )
    ),
  );
}