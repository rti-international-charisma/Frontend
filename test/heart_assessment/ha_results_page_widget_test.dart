import 'package:charisma/heart_assessment/ha_results_page_widget.dart';
import 'package:charisma/heart_assessment/ha_results_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../util/utils.dart';

void main() {
  testWidgets(
      'It displays the Heart Assessment results widget and footer links',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    await tester.pumpWidget(HAResultsPageWidget(
      apiClient: apiClient,
      assetsUrl: Utils.assetsUrl,
    ).wrapWithMaterial());

    expect(find.byKey(ValueKey('CharismaAppBar')), findsOneWidget);
    expect(find.byKey(ValueKey('HAResultsWidget')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('HAResultsWidget')).evaluate().single.widget
                as HAResultsWidget)
            .displayUserGreeting,
        equals(true));

    expect(find.byKey(ValueKey('CharismaFooterLinks'), skipOffstage: false),
        findsOneWidget);
  });
}
