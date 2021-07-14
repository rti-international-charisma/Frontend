import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/counselling_module/counselling_module_page_widget.dart';
import 'package:charisma/counselling_module/counselling_module_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../util/utils.dart';

void main() {
  Map<String, dynamic> moduleData = {
    "title": "Discussing PrEP Use With Partners",
    "introduction": "<p>This is intro</p>",
    "description": null,
    "summary": null,
    "heroImage": {
      "title": "PrEP Use Hero Image",
      "introduction": null,
      "summary": null,
      "imageUrl": "/assets/89390db4-434f-4d7d-92a0-152cd1368ecd"
    },
    "videoSection": {
      "introduction": null,
      "summary": null,
      "videos": [
        {
          "title": "Unhealthy PrEP Disclosure",
          "description": null,
          "videoUrl": "/assets/4136f966-36a8-4510-820d-b9979e1c558b",
          "youtubeVideoUrl": "https://www.youtube.com/watch?v=_QwXO1ChVPc",
          "videoImage": null,
          "actionText": "Learn more",
          "actionLink": null,
          "isPrivate": false
        },
        {
          "title": "Prep use video",
          "description": null,
          "videoUrl": "/assets/f317721b-7ae8-44e6-9954-0e7ab345c875",
          "youtubeVideoUrl": "https://www.youtube.com/watch?v=_QwXO1ChVPc",
          "videoImage": null,
          "actionText": "Learn More",
          "actionLink": null,
          "isPrivate": false
        }
      ]
    },
    "counsellingModuleSections": [
      {
        "id": "section_4",
        "title": "How to use PrEP without anyone knowing",
        "introduction": "<p>This is intro</p>",
        "summary": null,
        "accordionContent": [
          {
            "id": "section_4_accordion_1",
            "description": "This is description",
            "title": "Some title"
          }
        ]
      }
    ],
    "counsellingModuleActionPoints": [
      {"id": "model_prep_use_action_point_5", "title": "Some title"}
    ]
  };

  testWidgets('It displays all sections of the page',
      (WidgetTester tester) async {
    final ApiClient apiClient = MockApiClient();
    final module = Future<Map<String, dynamic>>.value(moduleData);
    String moduleName = 'prep_use';

    when(apiClient.getCounsellingModuleWithoutScore(moduleName))
        .thenAnswer((_) => module);

    await tester.pumpWidget(CounsellingModulePageWidget(
      apiClient: apiClient,
      moduleName: moduleName,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('CharismaAppBar')), findsOneWidget);
    expect(find.byKey(ValueKey('HeroImage')), findsOneWidget);
    expect(find.byKey(ValueKey('PageCounsellingModule')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('PageCounsellingModule')).evaluate().single.widget
                as CounsellingModuleWidget)
            .moduleData,
        equals(moduleData));

    expect(
      (find.byKey(ValueKey('HeroImage')).evaluate().single.widget as Image)
          .image,
      equals(NetworkImage(
          "${Utils.assetsUrl}${moduleData['heroImage']['imageUrl']}")),
    );

    // await tester.ensureVisible(
    //     find.byKey(ValueKey('CharismaFooterLinks'), skipOffstage: false));
    // await tester.pumpAndSettle();
    // expect(find.byKey(ValueKey('CharismaFooterLinks')), findsOneWidget);
  });
}
