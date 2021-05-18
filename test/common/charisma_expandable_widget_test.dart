import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../util/utils.dart';

void main() {
  var data = {
    "title": "This is title",
    "description": "<p>This is description</p>",
    "imageUrl": "/assets/image-id"
  };

  testWidgets('It displays all accordion content as expected',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
        CharismaExpandableWidget(data: data, assetsUrl: Utils.assetsUrl)
            .wrapWithMaterial()));

    expect(find.byKey(ValueKey('CharismaExpandableTitle')), findsOneWidget);
    expect(find.byKey(ValueKey('CharismaExpandableImage')), findsOneWidget);
    expect(
        find.byKey(ValueKey('CharismaExpandableDescription')), findsOneWidget);
  });
}
