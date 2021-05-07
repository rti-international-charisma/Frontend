import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/constants.dart';

import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

class HAResultsWidget extends StatelessWidget {
  const HAResultsWidget({Key? key, this.apiClient, this.assetsUrl})
      : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;

  num getSectionScore(List answersList) {
    return answersList.fold(
        0, (previousValue, answer) => previousValue + answer['score']);
  }

  String? getSectionScoreExplanation(String sectionType) {
    switch (sectionType) {
      case 'TRADITIONAL VALUES':
        return 'Women who have higher scores on these questions generally believe men should have more power than women in family or relationship decisions.';
      case 'PARTNER ABUSE AND CONTROL':
        return 'Women who score higher on these questions generally feel their partners are more controlling or abusive than women with lower scores.';
      case 'PARTNER SUPPORT':
        return 'Women who have higher scores on these questions generally believe men should have more power than women in family or relationship decisions. ';
      case 'PARTNER ATTITUDE TO HIV PREVENTION':
        return 'Women who score higher on these questions generally feel their partners are resistant to using HIV prevention methods than women with lower scores.';
      case 'HIV PREVENTION READINESS':
        return 'Women who score higher on these questions generally feel more ready to use HIV prevention methods than women with lower scores.';
    }
  }

  String? getConsentValueFromScore(int score) {
    switch (score) {
      case 1:
        return 'agree';
      case 2:
        return 'neutral';
      case 3:
        return 'oppose';
      case 4:
        return 'unaware';
    }
  }

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    Map<String, dynamic>? userData;
    Map<String, dynamic>? partnerContextSection;
    Map<String, dynamic>? abuseAndControlSection;
    bool isPartnerAware;
    num totalScore;

    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: SharedPreferenceHelper().getUserData()?.then((data) async {
              // If user is not logged in, then get the data stored on frontend
              // Else get it from the API
              if (data.isEmpty) {
                Map<String, dynamic>? results =
                    await SharedPreferenceHelper().getResultsData();

                return results;
              } else {
                userData = data;
                String? token = await SharedPreferenceHelper().getUserToken();

                return await apiClient?.getScores(token);
              }
            }),
            builder: (context, data) {
              if (data.hasData) {
                var scoreData = data.data as Map<String, dynamic>;
                var sectionScores = (scoreData['sections'] as List)
                    .where((section) =>
                        section['sectionType'] != 'PARTNER CONTEXT')
                    .toList();
                partnerContextSection = (scoreData['sections'] as List)
                    .where((section) =>
                        section['sectionType'] == 'PARTNER CONTEXT')
                    .toList()[0];
                abuseAndControlSection = (scoreData['sections'] as List)
                    .where((section) =>
                        section['sectionType'] == 'PARTNER ABUSE AND CONTROL')
                    .toList()[0];

                isPartnerAware =
                    partnerContextSection!['answers'][1]['score'] == 1;

                totalScore =
                    getSectionScore(abuseAndControlSection!['answers']);

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'HEART Assessment Test Results',
                              style: TextStyle(
                                color: infoTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              key: ValueKey('ScoresSection'),
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (userData != null)
                                        Text(
                                          'Hey ${userData!['username']},',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          key: ValueKey('UserGreeting'),
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Here's a summary of your responses:",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.black.withOpacity(0.04),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: sectionScores.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Column(
                                          key: ValueKey(
                                              'SectionScore&Explanation'),
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    sectionScores[index]
                                                        ['sectionType'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    key: ValueKey(
                                                        'SectionType$index'),
                                                  ),
                                                ),
                                                Text(
                                                  '${getSectionScore(sectionScores[index]['answers'])} of ${sectionScores[index]['answers'].length * 6}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                  key: ValueKey(
                                                      'SectionScore$index'),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  3, 5, 3, 0),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: textBorderColor,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                '${getSectionScoreExplanation(sectionScores[index]['sectionType'])}',
                                                style: TextStyle(fontSize: 12),
                                                key: ValueKey(
                                                    'SectionExplanation$index'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ternaryColor,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: TextButton(
                                    key: ValueKey('TakeTheTestButton'),
                                    child: Text(
                                      'Take the test again',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      routerDelegate.push(HALandingPageConfig);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            'Based on your responses, we think you will benefit from the information below',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: apiClient?.getCounsellingModule(
                          totalScore,
                          isPartnerAware
                              ? getConsentValueFromScore(
                                  partnerContextSection!['answers'][2]['score'])
                              : 'unaware'),
                      builder: (context, data) {
                        if (data.hasData) {
                          var moduleData = data.data as Map<String, dynamic>;
                          var moduleSections =
                              moduleData['counsellingModuleSections'];
                          var moduleActions =
                              moduleData['counsellingModuleActionPoints'];

                          return Column(
                            children: [
                              Container(
                                key: ValueKey('CounsellingModule'),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      moduleData["title"],
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      key: ValueKey('CounsellingModuleTitle'),
                                    ),
                                    Html(
                                      data: moduleData['introduction'],
                                      style: {
                                        'body': Style(color: infoTextColor)
                                      },
                                      key: ValueKey('CounsellingModuleIntro'),
                                    ),
                                    if (moduleData['moduleImage'] != null)
                                      Image.network(
                                        "$assetsUrl${moduleData['moduleImage']['imageUrl']}",
                                        fit: BoxFit.contain,
                                        key: ValueKey('ModuleImage'),
                                      ),
                                    if (moduleData['moduleVideo'] != null)
                                      Container(
                                        key: ValueKey('ModuleVideo'),
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: VideoPlayerWidget(
                                            "$assetsUrl${moduleData['moduleVideo']['videoUrl']}"),
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: moduleSections.length,
                                      itemBuilder: (BuildContext context,
                                              int sectionIndex) =>
                                          Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              moduleSections[sectionIndex]
                                                  ['title'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              key: ValueKey(
                                                  'SectionTitle$sectionIndex'),
                                            ),
                                          ),
                                          Html(
                                            data: moduleSections[sectionIndex]
                                                ['introduction'],
                                            key: ValueKey(
                                                'SectionIntro$sectionIndex'),
                                          ),
                                          if (moduleSections[sectionIndex]
                                                  ['accordionContent'] !=
                                              null)
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  moduleSections[sectionIndex]
                                                          ['accordionContent']
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int accordionIndex) =>
                                                      CharismaExpandableWidget(
                                                title: moduleSections[
                                                            sectionIndex]
                                                        ['accordionContent']
                                                    [accordionIndex]['title'],
                                                description: moduleSections[
                                                                sectionIndex]
                                                            ['accordionContent']
                                                        [accordionIndex]
                                                    ['description'],
                                                key: ValueKey(
                                                    'SectionAccordion$sectionIndex-$accordionIndex'),
                                              ),
                                            ),
                                          if (moduleSections[sectionIndex]
                                                  ['summary'] !=
                                              null)
                                            Html(
                                              data: moduleSections[sectionIndex]
                                                  ['summary'],
                                              key: ValueKey(
                                                  'SectionSummary$sectionIndex'),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                key: ValueKey('ActionPoints'),
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                color: ternaryColor,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        'Action points for you!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: moduleActions.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Card(
                                        margin: EdgeInsets.only(bottom: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            moduleActions[index]['title'],
                                            style: TextStyle(
                                              color: ternaryColor,
                                            ),
                                            key: ValueKey('ActionPoint$index'),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }

                        return Transform.scale(
                          scale: 0.1,
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                );
              }

              return Transform.scale(
                scale: 0.1,
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
