import 'package:charisma/common/charisma_footer_links_widget.dart';
import 'package:charisma/navigation/charisma_parser.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../util/utils.dart';

void main() {
  const links = [
    {'text': 'HIV Prevention: PrEP', 'url': null},
    {'text': 'Male Partner Information Pack', 'url': null},
    {'text': 'Referrals', 'url': null},
    {'text': 'Take the HEART assessment test', 'url': HALandingPagePath},
    {
      'text': 'Counselling Content',
      'links': [
        {
          'text': 'Partner Communication',
          'url': CounsellingModulePartnerCommPath
        },
        {'text': 'PrEP Disclosure', 'url': CounsellingModulePrepUsePath},
        {'text': 'Intimate Partner Violence', 'url': CounsellingModuleIPVPath},
      ]
    },
    {'text': 'About Us', 'url': AboutUsPath}
  ];

  Future testFooterLinks(
    int parentIndex,
    int index,
    Map<String, dynamic> linkData,
    MockRouterDelegate routerDelegate,
    CharismaParser _parser,
    WidgetTester tester,
  ) async {
    expect(
        find.byKey(ValueKey(
            'CharismaFooterLink${index != parentIndex ? "$parentIndex." : ""}$index')),
        findsOneWidget);

    TextButton footerLink = find
        .byKey(ValueKey(
            'CharismaFooterLink${index != parentIndex ? "$parentIndex." : ""}$index'))
        .evaluate()
        .single
        .widget as TextButton;
    expect((footerLink.child as Text).data, equals(linkData['text']));

    if (linkData['url'] != null) {
      Future<PageConfiguration> pageConfigFuture =
          _parser.parseRouteInformation(
        RouteInformation(
          location: linkData['url'] as String,
        ),
      );

      footerLink.onPressed!();
      await tester.pump(Duration.zero);
      pageConfigFuture
          .then((pageConfig) => verify(routerDelegate.push(pageConfig)));
    }
  }

  testWidgets(
      'It displays all footer links and navigates to a page on clicking them',
      (WidgetTester tester) async {
    MockRouterDelegate routerDelegate = MockRouterDelegate();
    final CharismaParser _parser = CharismaParser();

    await tester.pumpWidget(
        CharismaFooterLinks().wrapWithMaterialMockRouter(routerDelegate));

    for (var parentIndex = 0; parentIndex < links.length; parentIndex++) {
      var linkData = links[parentIndex];

      if (linkData['links'] == null) {
        await testFooterLinks(parentIndex, parentIndex, linkData,
            routerDelegate, _parser, tester);
      } else {
        for (var childIndex = 0;
            childIndex < (linkData['links'] as List).length;
            childIndex++) {
          var childLinkData = (linkData['links'] as List)[childIndex];

          await testFooterLinks(parentIndex, childIndex, childLinkData,
              routerDelegate, _parser, tester);
        }
      }
    }
  });
}
