import 'package:charisma/male_partner_info/male_partner_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../util/utils.dart';

void main() {
  Map<String, dynamic> pageData = {
    "title": "Male Partner Information Pack",
    "introduction": "<p>This is intro</p>",
    "description": "<p>This is description</p>",
    "summary": null,
    "heroImage": {
      "title": "Male Partner Info Pack Hero Image",
      "introduction": null,
      "personalisedMessage": null,
      "imageUrl": "/assets/21900150-2849-4786-8234-a6e9f4320028"
    },
    "documents": [
      {
        "title": "Condoms and HIV",
        "documentUrl": "/assets/720bf46b-775f-4025-bbc7-2f0c3299999a"
      },
      {
        "title": "Male medical circumcision",
        "documentUrl": "/assets/6f4bc133-eafc-45ec-9524-d1a73786c82b"
      },
      {
        "title": "PrEP Fact Sheet",
        "documentUrl": "/assets/7de0dfed-2227-411e-b448-5b6cee810556"
      },
      {
        "title": "HIV and Mixed Statuses",
        "documentUrl": "/assets/8f76192b-31bb-4e8d-8a15-3dba8d9421e9"
      },
      {
        "title": "HIV Testing",
        "documentUrl": "/assets/a44c872c-267c-4df9-aa89-3ffe619b0440"
      }
    ]
  };

  testWidgets('It displays Male Partner Info page content as expected',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();
    var data = Future<Map<String, dynamic>>.value(pageData);

    when(apiClient.get('/content/male_partner_info_pack'))
        .thenAnswer((_) => data);

    await tester.pumpWidget(
        MalePartnerInfoWidget(apiClient: apiClient, assetsUrl: Utils.assetsUrl)
            .wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());
    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('CharismaAppBar')), findsOneWidget);
    expect(find.byKey(ValueKey('MalePartnerInfoHeroImage')), findsOneWidget);
    expect(
        (find
                .byKey(ValueKey('MalePartnerInfoHeroImage'))
                .evaluate()
                .single
                .widget as Image)
            .image,
        equals(NetworkImage(
            "${Utils.assetsUrl}${pageData['heroImage']['imageUrl']}")));

    expect(find.byKey(ValueKey('MalePartnerInfoPageTitle')), findsOneWidget);
    expect(
        (find
                .byKey(ValueKey('MalePartnerInfoPageTitle'))
                .evaluate()
                .single
                .widget as Text)
            .data,
        equals(pageData['title']));

    expect(find.byKey(ValueKey('MalePartnerInfoIntro')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('MalePartnerInfoIntro')).evaluate().single.widget
                as Html)
            .data,
        equals(pageData['introduction']));

    expect(find.byKey(ValueKey('MalePartnerInfoDescription')), findsOneWidget);
    expect(
        (find
                .byKey(ValueKey('MalePartnerInfoDescription'))
                .evaluate()
                .single
                .widget as Html)
            .data,
        equals(pageData['description']));

    expect(
        find.byKey(ValueKey('MalePartnerInfoDocuments'), skipOffstage: false),
        findsNWidgets(5));
    var documents = pageData['documents'];
    for (var index = 0; index < documents.length; index++) {
      expect(find.byKey(ValueKey('MalePartnerInfoDoc-$index')), findsOneWidget);
      expect(
          (find
                  .byKey(ValueKey('MalePartnerInfoDoc-$index'))
                  .evaluate()
                  .single
                  .widget as Text)
              .data,
          equals(documents[index]['title']));
    }
    expect(find.byKey(ValueKey('CharismaFooterLinks')), findsOneWidget);
  });
}
