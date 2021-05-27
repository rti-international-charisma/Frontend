import 'package:carousel_slider/carousel_slider.dart';
import 'package:charisma/hiv_prevention_prep/hiv_prevention_prep_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../util/utils.dart';
import "package:universal_html/html.dart" as html;

void main() {
  Map<String, dynamic> pageData = {
    "title": "HIV Prevention: PrEP",
    "introduction": "<p>This is intro</p>",
    "description": "<p>This is description</p>",
    "summary": null,
    "heroImage": {
      "title": "HIV Prevention PrEP Hero Image",
      "introduction": null,
      "personalisedMessage": null,
      "imageUrl": "/assets/4d8f634c-7ee1-404c-941d-ebe456a4e7af"
    }
  };

  var links = [
    {
      "type": "HIV Prevention PrEP Link",
      "name": "B-Wise",
      "addressAndContactInfo": "https://bwisehealth.com/",
      "imageUrl": "/assets/f7fe6deb-841c-46e9-b0aa-cead54e36ae7"
    },
    {
      "type": "HIV Prevention PrEP Link",
      "name": "Health4Men PrEP4Life",
      "addressAndContactInfo": "https://www.health4men.co.za/prep4life/",
      "imageUrl": "/assets/c34af5e3-a451-49ac-9109-56a58d87fe27"
    },
    {
      "type": "HIV Prevention PrEP Link",
      "name": "My PrEP",
      "addressAndContactInfo": "https://www.myprep.co.za/",
      "imageUrl": "/assets/8c52f7ad-9a34-444b-9f17-83ec9b3e21f9"
    }
  ];

  testWidgets('It displays HIV Prevention PrEP page content as expected',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    var data = Future<Map<String, dynamic>>.value(pageData);
    var pageLinks = Future<List<Map<String, dynamic>>>.value(links);

    when(apiClient.get('/content/hiv_prevention_prep')).thenAnswer((_) => data);

    when(apiClient.get('/referrals?filter=HIV Prevention PrEP Link'))
        .thenAnswer((_) => pageLinks);

    await tester.pumpWidget(HIVPreventionPrepWidget(
            apiClient: apiClient, assetsUrl: Utils.assetsUrl)
        .wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());
    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('CharismaAppBar')), findsOneWidget);
    expect(find.byKey(ValueKey('HIVPreventionPrepHeroImage')), findsOneWidget);
    expect(
        (find
                .byKey(ValueKey('HIVPreventionPrepHeroImage'))
                .evaluate()
                .single
                .widget as Image)
            .image,
        equals(NetworkImage(
            "${Utils.assetsUrl}${pageData['heroImage']['imageUrl']}")));

    expect(
        (find
                .byKey(ValueKey('HIVPreventionPrepPageTitle'))
                .evaluate()
                .single
                .widget as Text)
            .data,
        equals(pageData['title']));
    expect(
        (find.byKey(ValueKey('HIVPreventionPrepIntro')).evaluate().single.widget
                as Html)
            .data,
        equals(pageData['introduction']));
    expect(
        (find
                .byKey(ValueKey('HIVPreventionPrepDescription'))
                .evaluate()
                .single
                .widget as Html)
            .data,
        equals(pageData['description']));

    expect(
        (find
                .byKey(ValueKey('HIVPreventionPrepExternalLinks'))
                .evaluate()
                .single
                .widget as CarouselSlider)
            .itemCount,
        equals(3));

    for (var index = 0; index < links.length; index++) {
      var data = links[index];

      await tester.ensureVisible(
          find.byKey(ValueKey('HIVPreventionPrepLinkName-$index')));
      await tester.pump(Duration.zero);
      expect(find.byKey(ValueKey('HIVPreventionPrepLinkName-$index')),
          findsOneWidget);
      expect(
          (find
                  .byKey(ValueKey('HIVPreventionPrepLinkName-$index'))
                  .evaluate()
                  .single
                  .widget as Text)
              .data,
          equals(data['name']));

      expect(
          (find
                  .byKey(ValueKey('HIVPreventionPrepLinkImage-$index'))
                  .evaluate()
                  .single
                  .widget as Image)
              .image,
          equals(NetworkImage("${Utils.assetsUrl}${data['imageUrl']}")));

      TextButton linkButton = find
          .byKey(ValueKey('HIVPreventionPrepLinkButton-$index'))
          .evaluate()
          .single
          .widget as TextButton;

      expect((linkButton.child as Text).data, equals('Visit Page'));

      // TODO: Find a way to mock this html.window method so that we can verify
      // whether the link passed to this button opens
      // linkButton.onPressed!();
      // verify(html.window.open(data['addressAndContactInfo']!, 'new tab'));
    }

    expect(find.byKey(ValueKey('CharismaFooterLinks')), findsOneWidget);
  });
}
