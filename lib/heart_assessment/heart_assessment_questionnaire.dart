

import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/heart_assessment/charisma_heart_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment.dart';
import 'package:charisma/heart_assessment/heart_assessment_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment_result.dart';
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
  Map<String, Map<String, int>> result = {};
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    return FutureBuilder<Map<String, dynamic>?>(
        future: widget.apiClient.get('/assessment'),
        builder: (context, data) {
          if (data.hasData) {
            HeartAssessment heartAssessment = HeartAssessment.fromJson(data.data!);
            return Scaffold(
              key: _scaffoldKey,
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
                    print('Close tapped');
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
                                child: QuestionWidget(++i, question as Question, (qId, selectedOption) {
                                  addOrUpdateResults(heartAssessment.assessment![currentDisplaySection].id!, qId, selectedOption);
                                  print('Result : $result');
                                }),
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
                                  if (areAllQuestionsInCurrentSectionCompleted(heartAssessment, result, currentDisplaySection)) {
                                    setState(() {
                                      currentDisplaySection++;
                                    });
                                    _scrollController.animateTo(
                                        _scrollController.position
                                            .minScrollExtent,
                                        duration: Duration(milliseconds: 10),
                                        curve: Curves.ease);
                                  } else {
                                    //Show Attempt questions error
                                    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                                        SnackBar(
                                          content: Text('Please answer all the questions.'),
                                          backgroundColor: Colors.red,
                                        ));
                                  }
                                } else {
                                  //Ready to submit
                                  createResultObject(heartAssessment);
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

  void addOrUpdateResults(String sectionId, String qId, int selectedOption) {
    if (result[sectionId] == null) {
      result[sectionId] = {};
    }
    result[sectionId]![qId] = selectedOption;
  }

  bool areAllQuestionsInCurrentSectionCompleted(HeartAssessment heartAssessment, Map<String, Map<String, int>> result, int currentDisplaySection) {
    var sectionId = heartAssessment.assessment![currentDisplaySection].id;
    var questions = heartAssessment.assessment![currentDisplaySection].questions;
    var attemptedQuestionAnswers = result[sectionId];
    if (questions!= null && attemptedQuestionAnswers != null && (attemptedQuestionAnswers.length == questions.length)) {
      print('All Questions answered');
      return true;
    } else {
      print('Questions incompleted');
      return false;
    }
  }

  void createResultObject(HeartAssessment heartAssessment) {
    List<Section> sectionsList = result.map((sectionId, QnAMap) {
      List<Answer> answers = [];
      QnAMap.forEach((qId, weightage) {
          answers.add(Answer(questionId: qId, score: weightage));
        });
        var section = Section(sectionId: sectionId, sectionType: getSectionTypeFromSectionId(heartAssessment, sectionId), answers: answers);
        return MapEntry(sectionId, section);
    }).values.toList();

    var json = HeartAssessmentResult(sections: sectionsList).toJson();

    print('Result json : $json');
  }

  String getSectionTypeFromSectionId(HeartAssessment heartAssessment, String sectionId) {
    //TODO: Add Section Type to Section once added from the BE
    return heartAssessment.assessment!.firstWhere((element) => element.section == sectionId).section ?? '';
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