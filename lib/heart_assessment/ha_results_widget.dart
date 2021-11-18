import 'dart:collection';

import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_circular_loader_widget.dart';
import 'package:charisma/common/charisma_error_handler_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/constants.dart';
import 'package:charisma/counselling_module/counselling_module_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/firebase.dart';

class HAResultsWidget extends StatelessWidget {
  const HAResultsWidget({
    Key? key,
    required this.apiClient,
    required this.assetsUrl,
    required this.displayUserGreeting,
    required this.analytics
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;
  final bool displayUserGreeting;
  final Analytics? analytics;

  num getSectionScore(List answersList) {
    return answersList.fold(
        0, (previousValue, answer) => previousValue + answer['score']);
  }

  String? getSectionScoreExplanation(String sectionType) {
    switch (sectionType) {
      case 'TRADITIONAL VALUES':
        return 'Green means you tend to think women and men have more equal power. Red means you think men should have more power.';
      case 'PARTNER ABUSE AND CONTROL':
        return 'Green means your partner isn’t abusive or controlling. If you scored red, you may feel he is controlling or abusive.';
      case 'PARTNER SUPPORT':
        return 'Green means your partner is generally supportive. Red means your partner may not be very supportive of you.';
      case 'PARTNER ATTITUDE TO HIV PREVENTION':
        return 'Green means your partner is supportive of HIV prevention. Red means your partner may be resistant to using HIV prevention.';
      case 'HIV PREVENTION READINESS':
        return 'If you scored green, you’re ready to use HIV prevention. Red means you may not feel ready to use HIV prevention.';
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

  Color _calcColour(String sectionType, num amount, num total, bool reverse) {
    amount = reverse ? amount : total - amount ;
    num colourNum = (((amount / total) * 100) / 33.33).toInt();
    switch (colourNum.toInt()) {
      case 0: return Colors.red;
      // case 1: return Colors.orange;
      case 1: return Colors.yellow;
      // case 3: return Colors.yellowAccent;
      // case 4: return Colors.lightGreenAccent;
      case 3: return Colors.lightGreenAccent.shade700;
      default: return Colors.lightGreenAccent.shade700;
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

    return FutureBuilder(
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
              .where((section) => section['sectionType'] != 'PARTNER CONTEXT')
              .toList();
          partnerContextSection = (scoreData['sections'] as List)
              .where((section) => section['sectionType'] == 'PARTNER CONTEXT')
              .toList()[0];
          abuseAndControlSection = (scoreData['sections'] as List)
              .where((section) =>
                  section['sectionType'] == 'PARTNER ABUSE AND CONTROL')
              .toList()[0];

          isPartnerAware = partnerContextSection!['answers'][1]['score'] == 1;

          totalScore = getSectionScore(abuseAndControlSection!['answers']);

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'HEART Quiz Results',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 25,
                                      height:25,
                                      decoration: BoxDecoration(
                                          color: Colors.lightGreenAccent.shade700,
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                    Text("High"),
                                    SizedBox(width: 5),
                                    Container(
                                      width: 25,
                                      height:25,
                                      decoration: BoxDecoration(
                                          color: Colors.yellowAccent,
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                    Text("Average"),
                                    SizedBox(width: 5),
                                    Container(
                                      width: 25,
                                      height:25,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle
                                      ),
                                    ),
                                    Text("Low"),
                                    SizedBox(width: 5)
                                  ],),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Container(
                                //       width: 25,
                                //       height:25,
                                //       decoration: BoxDecoration(
                                //           color: Colors.yellow,
                                //           shape: BoxShape.circle
                                //       ),
                                //     ),
                                //     Text("Below Average"),
                                //     // SizedBox(width: 5),
                                //     // Container(
                                //     //   width: 25,
                                //     //   height:25,
                                //     //   decoration: BoxDecoration(
                                //     //       color: Colors.orange,
                                //     //       shape: BoxShape.circle
                                //     //   ),
                                //     // ),
                                //     // Text("Poor"),
                                //     SizedBox(width: 5),
                                //     Container(
                                //       width: 25,
                                //       height:25,
                                //       decoration: BoxDecoration(
                                //           color: Colors.red,
                                //           shape: BoxShape.circle
                                //       ),
                                //     ),
                                //     Text("Low"),
                                //     SizedBox(width: 5)
                                //   ],),
                                SizedBox(
                                  height: 10,
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
                                ),

                                if (displayUserGreeting && userData != null)
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
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: sectionScores.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Column(
                                    key: ValueKey('SectionScore&Explanation'),
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              sectionScores[index]
                                                  ['sectionType'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              key:
                                                  ValueKey('SectionType$index'),
                                            ),
                                          ),
                                          Container(
                                            width: 25,
                                            height:25,
                                            decoration: BoxDecoration(
                                              color: _calcColour(sectionScores[index]['sectionType'], getSectionScore(sectionScores[index]['answers']), sectionScores[index]['answers'].length * 6, isReverse(sectionScores[index]['sectionType'])),
                                              shape: BoxShape.circle
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
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
                                'Take the quiz again',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                routerDelegate.replace(HALandingPageConfig);
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
                    var title = (moduleData['title'] as String).replaceAll(" ", "_");
                    analytics!.setCurrentScreen("/recommend/" + title);
                    analytics!.logEvent("/recommend/" + title, new HashMap());

                    return CounsellingModuleWidget(
                      moduleData: moduleData,
                      assetsUrl: assetsUrl,
                    );
                  } else if (data.hasError) {
                    return CharismaErrorHandlerWidget(
                      error: data.error as ErrorBody,
                    );
                  }

                  return CharismaCircularLoader();
                },
              )
            ],
          );
        } else if (data.hasError) {
          return CharismaErrorHandlerWidget(
            error: data.error as ErrorBody,
          );
        }

        return CharismaCircularLoader();
      },
    );
  }

  bool isReverse(String type) {
    var bool =  type == 'PARTNER SUPPORT' || type == 'HIV PREVENTION READINESS';
    return bool;
  }
}
