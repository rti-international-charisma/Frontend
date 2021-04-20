

import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/heart_assessment/charisma_heart_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment.dart';
import 'package:charisma/heart_assessment/heart_assessment_app_bar.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'heart_assessment_question.dart';

class HeartAssessmentQuestionnaireWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HeartAssessmentQuestionaireState();

  final ApiClient apiClient;

  HeartAssessmentQuestionnaireWidget({Key? key, required this.apiClient}): super(key: key);
}

class _HeartAssessmentQuestionaireState extends State<HeartAssessmentQuestionnaireWidget> {

  int currentDisplaySection = 0;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    // var heartAssessment = HeartAssessment.fromJson(getHearAssessment());

    return FutureBuilder<Map<String, dynamic>?>(
        future: widget.apiClient.get('/assessment'),
        builder: (context, data) {
          if (data.hasData) {
            var heartAssessment = HeartAssessment.fromJson(data.data!);
            return Scaffold(
              appBar: CharismaHEARTAppBar(
                height: 237,
                child: HeartAssessmentAppBar(
                  fieldKey: 'HAAppBar',
                  sectionCount: 'Section ${currentDisplaySection +
                      1} of ${heartAssessment.assessment!.length} ',
                  title: heartAssessment.assessment![currentDisplaySection].section,
                  introduction: heartAssessment.assessment![currentDisplaySection]
                      .introduction,
                  closeTapped: () {
                    routerDelegate.popRoute();
                  },
                ),
              ),
              body: SingleChildScrollView(
                key: ValueKey('HAMainScroll'),
                controller: _scrollController,
                child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: mapIndexed(
                              heartAssessment.assessment ? [currentDisplaySection]
                                  .questions, (i, question) =>
                              Container(
                                child: QuestionWidget(++i, question as Question),
                              )).toList(),
                        ),
                      ),
                      SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                              key: ValueKey('HANextDoneButton'),
                              onPressed: () {
                                if (currentDisplaySection <
                                    (heartAssessment.assessment!.length - 1)) {
                                  setState(() {
                                    currentDisplaySection++;
                                  });
                                  _scrollController.animateTo(
                                      _scrollController.position.minScrollExtent,
                                      duration: Duration(milliseconds: 10),
                                      curve: Curves.ease);
                                } else {
                                  //Ready to submit
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  primary: ternaryColor
                              ),
                              child: Text(
                                  currentDisplaySection <
                                      (heartAssessment.assessment!.length - 1)
                                      ? 'Next'
                                      : 'Done',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700
                                  ))
                          )
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                              key: ValueKey('HABackButton'),
                              onPressed: () {
                                if (currentDisplaySection > 0) {
                                  setState(() {
                                    currentDisplaySection--;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  primary: Colors.white
                              ),
                              child: Text(
                                'Back',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black
                                ),)
                          )
                      ),
                      SizedBox(height: 34),
                    ]
                ),
              ),
            );
          } else if (data.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
          }
          return Text('Fetching data');
        }
    );
  }
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T>? items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items!) {
    yield f(index, item);
    index = index + 1;
  }
}