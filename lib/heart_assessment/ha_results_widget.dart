import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:charisma/constants.dart';
import 'package:charisma/heart_assessment/heart_assessment_result_model.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:provider/provider.dart';

class HAResultsWidget extends StatelessWidget {
  const HAResultsWidget({Key? key}) : super(key: key);

  static const apiBaseUrl = 'http://0.0.0.0:8080';
  static ApiClient apiClient = ApiClient(
    http.Client(),
    apiBaseUrl,
  );

  num getSectionScore(questionsList) {
    return (questionsList as List)
        .fold(0, (previousValue, element) => previousValue + element['score']);
  }

  String? getSectionScoreExplanation(sectionType) {
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

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    Map<String, dynamic>? userData;

    return Scaffold(
      appBar: CharismaAppBar(
        apiClient: apiClient,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: apiClient.getCounsellingModule()?.then((moduleData) async {
              userData = await apiClient.getUserData() as Map<String, dynamic>;

              return moduleData;
            }),
            builder: (context, data) {
              if (data.hasData) {
                var resultsData = data.data as Map<String, dynamic>;
                var scoreData = resultsData['score'];
                var sectionScores = (scoreData['sections'] as List)
                    .where((section) =>
                        section['sectionType'] != 'PARTNER CONTEXT')
                    .toList();
                var moduleData = resultsData['module'];
                var moduleSections = moduleData['counsellinModuleSections'];
                var moduleActions = moduleData['counsellingModuleActionPoints'];

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
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hey ${userData!['username']},',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                                        color: Colors.black,
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
                                                  ),
                                                ),
                                                Text(
                                                  '${getSectionScore(sectionScores[index]['questions'])} of ${sectionScores[index]['questions'].length * 6}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  3, 10, 3, 0),
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
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            moduleData["title"],
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Html(
                            data: moduleData['introduction'],
                            style: {'body': Style(color: infoTextColor)},
                          ),
                          Image.network(
                            "$apiBaseUrl${moduleData['heroImage']['imageUrl']}",
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: moduleSections.length,
                            itemBuilder:
                                (BuildContext context, int sectionIndex) =>
                                    Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    moduleSections[sectionIndex]['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Html(
                                  data: moduleSections[sectionIndex]
                                      ['introduction'],
                                ),
                                if (moduleSections[sectionIndex]
                                        ['accordionContent'] !=
                                    null)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: moduleSections[sectionIndex]
                                            ['accordionContent']
                                        .length,
                                    itemBuilder: (BuildContext context,
                                            int accordionIndex) =>
                                        CharismaExpandableWidget(
                                      title: moduleSections[sectionIndex]
                                              ['accordionContent']
                                          [accordionIndex]['title'],
                                      description: moduleSections[sectionIndex]
                                              ['accordionContent']
                                          [accordionIndex]['description'],
                                    ),
                                  ),
                                if (moduleSections[sectionIndex]['summary'] !=
                                    null)
                                  Html(
                                    data: moduleSections[sectionIndex]
                                        ['summary'],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                            itemBuilder: (BuildContext context, int index) =>
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
          ),
        ),
      ),
    );
  }
}
