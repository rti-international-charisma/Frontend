import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/common/youtube_player_widget.dart';
import 'package:charisma/counselling_module/counselling_module_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
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
          "title": "Prep use video",
          "description": null,
          "videoUrl": "/assets/2b22ad56-c682-4167-817b-e8c55aff51e0",
          "youtubeVideoUrl": "https://www.youtube.com/watch?v=_QwXO1ChVPc",
          "videoImage": null,
          "actionText": "Learn more",
          "actionLink": null,
          "isPrivate": false
        },
        {
          "title": "Prep use video 2",
          "description": null,
          "videoUrl": "/assets/2b22ad56-c682-4167-817b-e8c5vbdsff51e0",
          "youtubeVideoUrl": "https://www.youtube.com/watch?v=_QwXO1ChVPc",
          "videoImage": null,
          "actionText": "Learn more",
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

  testWidgets('It displays counselling module content',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CounsellingModuleWidget(
        moduleData: moduleData,
        assetsUrl: Utils.assetsUrl,
      ).wrapWithMaterial(),
    );
    await mockNetworkImagesFor(() => tester.pump());

    await tester.pump(Duration.zero);

    expect(find.byKey(ValueKey('CounsellingModule')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('CounsellingModuleTitle')).evaluate().single.widget
                as Text)
            .data,
        equals(moduleData['title']));
    expect(
        (find.byKey(ValueKey('CounsellingModuleIntro')).evaluate().single.widget
                as Html)
            .data,
        equals(moduleData['introduction']));

    expect(find.byKey(ValueKey('ModuleVideo')), findsNWidgets(2));

    expect(
        ((find.byKey(ValueKey('ModuleVideo')).first.evaluate().single.widget
                    as Container)
                .child as YoutubePlayerWidget)
            .runtimeType,
        equals(YoutubePlayerWidget));
    expect(
        ((find.byKey(ValueKey('ModuleVideo')).first.evaluate().single.widget
                    as Container)
                .child as YoutubePlayerWidget)
            .videoUrl,
        equals(
            "${moduleData['videoSection']['videos'][0]['youtubeVideoUrl']}"));

    List<Map<String, dynamic>> counsellingModuleSections =
        moduleData['counsellingModuleSections'];
    for (var sectionIndex = 0;
        sectionIndex < counsellingModuleSections.length;
        sectionIndex++) {
      Map<String, dynamic> sectionData =
          counsellingModuleSections[sectionIndex];

      expect(
          (find
                  .byKey(ValueKey('SectionTitle$sectionIndex'))
                  .evaluate()
                  .single
                  .widget as Text)
              .data,
          sectionData['title']);
      expect(
          (find
                  .byKey(ValueKey('SectionIntro$sectionIndex'))
                  .evaluate()
                  .single
                  .widget as Html)
              .data,
          sectionData['introduction']);
      if (sectionData['summary'] != null) {
        expect(
            (find
                    .byKey(ValueKey('SectionSummary$sectionIndex'))
                    .evaluate()
                    .single
                    .widget as Html)
                .data,
            sectionData['summary']);
      }

      if (sectionData['accordionContent'] != null) {
        List<Map<String, dynamic>> accordionList =
            sectionData['accordionContent'];
        for (var accordionIndex = 0;
            accordionIndex < accordionList.length;
            accordionIndex++) {
          Map<String, dynamic> accordionData = accordionList[accordionIndex];

          expect(
              find.byKey(
                  ValueKey('SectionAccordion$sectionIndex-$accordionIndex')),
              findsOneWidget);

          CharismaExpandableWidget sectionAccordionWidget = find
              .byKey(ValueKey('SectionAccordion$sectionIndex-$accordionIndex'))
              .evaluate()
              .single
              .widget as CharismaExpandableWidget;

          expect(sectionAccordionWidget.data, equals(accordionData));
        }
      }
    }

    expect(find.byKey(ValueKey('ActionPoints')), findsOneWidget);
    List<Map<String, dynamic>> actionPoints =
        moduleData['counsellingModuleActionPoints'];

    for (var actionPointIndex = 0;
        actionPointIndex < actionPoints.length;
        actionPointIndex++) {
      Map<String, dynamic> actionPointData = actionPoints[actionPointIndex];

      expect(
          (find
                  .byKey(ValueKey('ActionPoint$actionPointIndex'))
                  .evaluate()
                  .single
                  .widget as Text)
              .data,
          equals(actionPointData['title']));
    }
  });
}
