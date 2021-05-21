import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/heart_assessment/ha_results_page_widget.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:charisma/referrals/referrals_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import "package:collection/collection.dart";
import '../util/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var referralPageData = {
    "title": "Referrals",
    "introduction": "<p>This is intro</p>",
    "description": null,
    "summary": null,
    "heroImage": {
      "title": "Referrals Hero Image",
      "introduction": "",
      "personalisedMessage": null,
      "imageUrl": "/assets/3e6abf40-45d1-40b9-9aa8-15ab545862d1"
    }
  };

  var referralsData = [
    {
      "type": "Shelters (Adult)",
      "name": "POWA (People opposing women abuse)",
      "addressAndContactInfo":
          "Berea​\n011 642 4345/6​\nPowa Soweto ​\nRoom 10 Nthabiseng Centre, \nChris Hani Hospital",
      "imageUrl": "/assets/b08bec43-1be6-4ef5-b7b2-cedb1b6cfedd"
    },
    {
      "type": "Shelters (Adult)",
      "name": "Eldorado Park Women’s Forum",
      "addressAndContactInfo":
          "Eldorado Park\n011 945 6433\nEvans Gassi 072 950 7626",
      "imageUrl": "/assets/5b735312-0152-45e5-b7ba-34cc8f506aa9"
    },
    {
      "type": "Counselling",
      "name": "Lifeline/Victim Empowerment",
      "addressAndContactInfo":
          "Booysens\nSgt. Mothibi 011 433 5386 \nSinenhlanhla (social worker) \nsinenhlanhla@lifelinejhb.org.za 011 728 1331",
      "imageUrl": "/assets/65de9bf3-50a7-4d06-a410-a7aed7fbb3ac"
    },
    {
      "type": "Counselling",
      "name": "​SANCA​",
      "addressAndContactInfo":
          "62 Marshall Street​\nKhotso House, 5th floor Suite 530​\nMarshalltown, Johannesburg​\nTel; 011 836 2460​\nFax: 011 836 2461",
      "imageUrl": "/assets/265ad85b-a989-41b9-bdc0-518cb3dd7f61"
    },
    {
      "type": "Legal Assistance",
      "name": "Saturday Clinic",
      "addressAndContactInfo": "Wits RHI steps \nNurina 071 862 0076",
      "imageUrl": "/assets/a9aacc9d-1271-44d6-a681-101b4c7875f7"
    },
  ];

  testWidgets('It displays referrals page as expected',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    var pageData = Future<Map<String, dynamic>>.value(referralPageData);
    var referrals = Future<List<Map<String, dynamic>>>.value(referralsData);

    when(apiClient.get('/content/referral_intro')).thenAnswer((_) => pageData);

    when(apiClient.get('/referrals')).thenAnswer((_) => referrals);

    await tester.pumpWidget(
        ReferralsWidget(apiClient: apiClient, assetsUrl: Utils.assetsUrl)
            .wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());
    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('ReferralHeroImage')), findsOneWidget);
    expect(find.byKey(ValueKey('ReferralIntro')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('ReferralIntro')).evaluate().single.widget as Html)
            .data,
        equals(referralPageData['introduction']));
    expect(find.byKey(ValueKey('ReferralExpandableListFor-Shelters (Adult)')),
        findsOneWidget);
    expect(find.byKey(ValueKey('ReferralExpandableListFor-Counselling')),
        findsOneWidget);
    expect(find.byKey(ValueKey('ReferralExpandableListFor-Legal Assistance')),
        findsOneWidget);
    expect(find.byKey(ValueKey('CharismaExpandableTitle')), findsNWidgets(3));

    var referralsGroupedList = groupBy(referralsData,
        (referralData) => (referralData as Map<String, dynamic>)['type']);

    for (var index = 0; index < referralsGroupedList.keys.length; index++) {
      expect(
          (find
                  .byKey(ValueKey('CharismaExpandableTitle'))
                  .at(index)
                  .evaluate()
                  .single
                  .widget as Text)
              .data,
          equals(referralsGroupedList.keys.elementAt(index)));
    }

    referralsGroupedList.entries.forEach((element) {
      for (var index = 0; index < element.value.length; index++) {
        var data = element.value[index];
        expect(find.byKey(ValueKey('ReferralLogo-${element.key}-$index')),
            findsOneWidget);
        expect(
            (find
                    .byKey(ValueKey('ReferralLogo-${element.key}-$index'))
                    .evaluate()
                    .single
                    .widget as Image)
                .image,
            equals(NetworkImage("${Utils.assetsUrl}${data['imageUrl']}")));

        expect(find.byKey(ValueKey('ReferralName-${element.key}-$index')),
            findsOneWidget);
        expect(
            (find
                    .byKey(ValueKey('ReferralName-${element.key}-$index'))
                    .evaluate()
                    .single
                    .widget as Text)
                .data,
            equals(data['name']));

        expect(
            find.byKey(
                ValueKey('ReferralAddressContactInfo-${element.key}-$index')),
            findsOneWidget);
        expect(
            (find
                    .byKey(ValueKey(
                        'ReferralAddressContactInfo-${element.key}-$index'))
                    .evaluate()
                    .single
                    .widget as Html)
                .data,
            data['addressAndContactInfo']);
      }
    });
  });
}
