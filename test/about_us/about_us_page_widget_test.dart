import 'package:charisma/about_us/about_us_page_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../util/utils.dart';

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

  testWidgets('It renders About Us page as expected',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get('/content/aboutus')).thenAnswer(
        (realInvocation) => Future<Map<String, dynamic>>.value(pageContent));

    await tester.pumpWidget(AboutUs(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('CharismaAppBar')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('AboutUsHeadlineImage')).evaluate().single.widget
                as Image)
            .image,
        equals(NetworkImage(
            "${Utils.assetsUrl}${(pageContent['images'] as List).elementAt(0)['imageUrl']}")));
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
        equals((pageContent['images'] as List).elementAt(1)['title']));
    expect(
        (find.byKey(ValueKey('AboutUsHEARTImage')).evaluate().single.widget
                as Image)
            .image,
        equals(NetworkImage(
            "${Utils.assetsUrl}${(pageContent['images'] as List).elementAt(1)['imageUrl']}")));
    expect(
        (find.byKey(ValueKey('AboutUsSummary')).evaluate().single.widget
                as Html)
            .data,
        equals(pageContent['summary']));

    await tester.ensureVisible(
        find.byKey(ValueKey('CharismaFooterLinks'), skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('CharismaFooterLinks')), findsOneWidget);
  });
}
