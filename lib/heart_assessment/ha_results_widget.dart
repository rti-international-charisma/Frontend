import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:charisma/constants.dart';
import 'package:charisma/heart_assessment/heart_assessment_result_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class HAResultsWidget extends StatelessWidget {
  const HAResultsWidget({Key? key}) : super(key: key);

  static const apiBaseUrl = 'http://0.0.0.0:8080';
  static ApiClient apiClient = ApiClient(
    http.Client(),
    apiBaseUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(
        apiClient: apiClient,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: apiClient.getCounsellingModule(),
            builder: (context, data) {
              if (data.hasData) {
                var moduleData = data.data as Map<String, dynamic>;
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
