import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/counselling_module/counselling_module_page_widget.dart';
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
    "moduleVideo": {"videoUrl": "/assets/9fd45ac0-e7e3-4d26-b75f-62c0125bf6ec"},
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
    when(apiClient.getCounsellingModuleWithoutScore('healthy_relationship'))
        .thenAnswer((_) => module);

    await tester.pumpWidget(CounsellingModulePageWidget(
      apiClient: apiClient,
      moduleName: moduleName,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HeroImage')), findsOneWidget);
    expect(find.byKey(ValueKey('HealthyRelationshipModule')), findsOneWidget);
    expect(find.byKey(ValueKey('PageCounsellingModule')), findsOneWidget);

    expect(
        (find.byKey(ValueKey('HeroImage')).evaluate().single.widget as Image)
            .image,
        equals(NetworkImage(
            "${Utils.assetsUrl}${moduleData['heroImage']['imageUrl']}")));
  });
}
