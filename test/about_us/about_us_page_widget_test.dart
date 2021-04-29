import 'package:charisma/about_us/about_us_page_widget.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/network_image_builder_mock.dart';

void main() {
  var pageContent = {
    "title": "About Us",
    "introduction": "<p>This is intro</p>",
    "summary": "<p>This is summary</p>",
    "description": "<p>This is desc</p>",
    "images": [
      {
        "title": "Image Title 1",
        "imageUrl": "/assets/a060a1f1-c8ee-4cc0-ad1c-b99f91d5bedf"
      },
      {
        "title": "Image Title 2",
        "imageUrl": "/assets/a3a5fa28-c27b-4a09-8edc-d60c33deeb3a"
      }
    ]
  };

  testWidgets('It renders all the content as expected',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    const apiBaseUrl = 'http://0.0.0.0:8080';

    when(apiClient.get('/aboutus')).thenAnswer(
        (realInvocation) => Future<Map<String, dynamic>>.value(pageContent));

    await tester.pumpWidget(AboutUs(
      apiClient: apiClient,
      apiBaseUrl: apiBaseUrl,
    ).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(
        (find.byKey(ValueKey('AboutUsHeadlineImage')).evaluate().single.widget
                as Image)
            .image,
        equals(NetworkImage(
            "$apiBaseUrl${(pageContent['images'] as List).elementAt(1)['imageUrl']}")));
    expect(
        (find.byKey(ValueKey('AboutUsTitle')).evaluate().single.widget as Text)
            .data,
        equals(pageContent['title']));
    expect(
        (find.byKey(ValueKey('AboutUsIntro')).evaluate().single.widget as Html)
            .data,
        equals(pageContent['introduction']));
    expect(
        (find.byKey(ValueKey('AboutUsDescription')).evaluate().single.widget
                as Html)
            .data,
        equals(pageContent['description']));
    expect(
        (find.byKey(ValueKey('AboutUsDescription')).evaluate().single.widget
                as Html)
            .data,
        equals(pageContent['description']));
    expect(
        (find.byKey(ValueKey('AboutUsHEARTTitle')).evaluate().single.widget
                as Text)
            .data,
        equals((pageContent['images'] as List).elementAt(0)['title']));
    expect(
        (find.byKey(ValueKey('AboutUsHEARTImage')).evaluate().single.widget
                as Image)
            .image,
        equals(NetworkImage(
            "$apiBaseUrl${(pageContent['images'] as List).elementAt(0)['imageUrl']}")));
    expect(
        (find.byKey(ValueKey('AboutUsSummary')).evaluate().single.widget
                as Html)
            .data,
        equals(pageContent['summary']));
  });
}

class MockApiClient extends Mock implements ApiClient {}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (ctx) => MockNetworkImageBuilder()),
          Provider<Future<SharedPreferences>>(
              create: (_) => SharedPreferences.getInstance()),
          InheritedProvider<CharismaRouterDelegate>(
              create: (ctx) => CharismaRouterDelegate(MockApiClient()))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: this,
        )),
      );
}
