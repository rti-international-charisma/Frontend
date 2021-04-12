import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/heart_assessment/heart_assessment_landing_page_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../util/network_image_builder_mock.dart';

void main() {
  var pageContent = {
    "data": {
      "id": 1,
      "page_content": {
        "name": "Heart Assessment Landing Page",
        "status": "published",
        "user_created": "2e2e2552-bac2-42c2-84b6-18f8eeb22aae",
        "date_created": "2021-04-08T09:26:49Z",
        "user_updated": null,
        "date_updated": null,
        "title": "HEART Assessment Introduction",
        "summary":
            "<p>&bull; &nbsp; &nbsp;Disagree or Agree, and then &nbsp;<br />&bull; &nbsp; &nbsp;How much you disagree or agree: A Lot, Somewhat or A Little</p>\n<p>And finally, try to answer the questions about yourself and about your relationship with your partner(s) as honestly and openly as you can. These questions will help determine what kind of counselling and support related to the use of PrEP you might need.&nbsp;</p>\n<p>Remember, all your answers will be kept confidential.</p>",
        "introduction":
            "<p><span style=\"font-size: 14pt;\"><strong>Hi there, you&rsquo;re about to take the HEAlthy Relationship Test (HEART assessment).&nbsp;</strong></span><br /><span style=\"font-size: 14pt;\"><strong>Go you for taking this step!&nbsp;</strong></span></p>\n<p><span style=\"font-size: 14pt;\">We think it&rsquo;s useful to find out what limits or risks you might face in your relationship that could stop you from using PrEP. It may also help you see what&rsquo;s healthy or not in your relationship. We&rsquo;ll use your score to advise you on the content and skills we think could work for you in your relationship and PrEP use journey.&nbsp;</span></p>\n<p><span style=\"font-size: 14pt;\">When you&rsquo;re taking the HEART assessment, remember to keep your main partner in mind. If you don&rsquo;t have a main partner, it&rsquo;s helpful to think about which partner or partners might affect your PrEP use the most.&nbsp;</span></p>\n<p><span style=\"font-size: 14pt;\">A quick note about responding to the questions. For each question, you have 5 options based on how much you agree or disagree with the statement you&rsquo;re reading:</span></p>",
        "image_file": "4f19ac87-6b09-4147-88aa-1b93f41ee758"
      }
    }
  };

  testWidgets('It displays app bar title', (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/page/heart_assessment_landing_page"))
        .thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(pageContent);
    });

    await tester.pumpWidget(
        HeartAssessmentLandingPageWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HAPageTitle')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('HAPageTitle')).evaluate().single.widget as Text)
            .data,
        equals((pageContent['data']!['page_content']
            as Map<String, dynamic>)['title']));
  });

  testWidgets('It displays page content', (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/page/heart_assessment_landing_page"))
        .thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(pageContent);
    });

    await tester.pumpWidget(
        HeartAssessmentLandingPageWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HAIntro')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('HAIntro')).evaluate().single.widget as Html).data,
        equals((pageContent['data']!['page_content']
            as Map<String, dynamic>)['introduction']));

    expect(find.byKey(ValueKey('HAIntroImage')), findsOneWidget);

    expect(find.byKey(ValueKey('HASummary')), findsOneWidget);
    expect(
        (find.byKey(ValueKey('HASummary')).evaluate().single.widget as Html)
            .data,
        equals((pageContent['data']!['page_content']
            as Map<String, dynamic>)['summary']));
  });

  testWidgets('It displays an action button named "Get started"',
      (WidgetTester tester) async {
    final apiClient = MockApiClient();

    when(apiClient.get("/page/heart_assessment_landing_page"))
        .thenAnswer((realInvocation) {
      return Future<Map<String, dynamic>>.value(pageContent);
    });

    await tester.pumpWidget(
        HeartAssessmentLandingPageWidget(apiClient: apiClient)
            .wrapWithMaterial());
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byKey(ValueKey('HAGetStarted')), findsOneWidget);
    expect(
        ((find.byKey(ValueKey('HAGetStarted')).evaluate().single.widget
                    as TextButton)
                .child as Text)
            .data,
        equals('Get started'));
  });
}

class MockApiClient extends Mock implements ApiClient {}

extension on Widget {
  Widget wrapWithMaterial() => MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (ctx) => MockNetworkImageBuilder()),
          InheritedProvider<CharismaRouterDelegate>(
              create: (ctx) => CharismaRouterDelegate(MockApiClient()))
        ],
        child: MaterialApp(
            home: Scaffold(
          body: this,
        )),
      );
}
