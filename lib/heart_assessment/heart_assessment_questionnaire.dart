import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/heart_assessment/charisma_heart_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment_model.dart';
import 'package:charisma/heart_assessment/heart_assessment_result_model.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'heart_assessment_question.dart';

class HeartAssessmentQuestionnaireWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HeartAssessmentQuestionaireState();

  final ApiClient apiClient;

  HeartAssessmentQuestionnaireWidget({Key? key, required this.apiClient})
      : super(key: key);
}

class _HeartAssessmentQuestionaireState
    extends State<HeartAssessmentQuestionnaireWidget> {
  int currentDisplaySection = -1;
  ScrollController _scrollController = ScrollController();
  Map<String, Map<String, int>> result = {};
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool isLoading = false;

  var scoresCache, questionsCache;

  Future<dynamic> getScores() async {
    String? userToken = await SharedPreferenceHelper().getUserToken();
    if (userToken != null) {
      if (scoresCache != null) {
        return scoresCache;
      } else {
        var scores = await widget.apiClient.getScores(userToken);
        scoresCache = HeartAssessmentResult.fromJson(scores);
        return scoresCache;
      }
    } else {
      return Future.value(null);
    }
  }

  Future<dynamic> getQuestions() async {
    if (questionsCache != null) {
      return questionsCache;
    } else {
      questionsCache = await widget.apiClient.get('/assessments')!;
      return questionsCache;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    return FutureBuilder(
        future: Future.wait([getScores(),getQuestions()]),
        builder: (context, data) {
          if (data.hasData) {
            var questionsData = (data.data as List)[1];
            var scoresData = (data.data as List)[0];
            if(scoresData != null) {
              result = mapScoreResultToResult(scoresData);
              if (result.length < (scoresData as HeartAssessmentResult).totalSections && currentDisplaySection == -1) {
                 currentDisplaySection = result.length;
              } else if(currentDisplaySection == -1) {
                currentDisplaySection = 0;
              }
              print('Attempted Questions and Answers $result');
            } else if(currentDisplaySection == -1) {
              currentDisplaySection = 0;
            }
            HeartAssessment heartAssessment =
                HeartAssessment.fromJson(questionsData!);
            return Scaffold(
              key: _scaffoldKey,
              appBar: CharismaHEARTAppBar(
                height: 180,
                child: HeartAssessmentAppBar(
                  fieldKey: 'HAAppBar',
                  sectionCount:
                      'Section ${currentDisplaySection + 1} of ${heartAssessment.assessment!.length} ',
                  title: heartAssessment
                      .assessment![currentDisplaySection].section,
                  introduction: heartAssessment
                      .assessment![currentDisplaySection].introduction,
                  closeTapped: () {
                    print('Close tapped');
                    routerDelegate.popRoute();
                  },
                ),
              ),
              body: Stack(children: [
                if (isLoading)
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator())),
                SingleChildScrollView(
                  key: ValueKey('HAMainScroll'),
                  controller: _scrollController,
                  child: Column(children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: mapIndexed(
                            heartAssessment.assessment?[currentDisplaySection].questions,
                            (i, question) =>
                                Container(
                                  child:
                                  QuestionWidget(
                                    key: ValueKey('QW_${(question as Question).id}'),
                                      index: ++i,
                                      heartQuestion: question as Question,
                                      optionSelected: (qId, selectedOption) {
                                        addOrUpdateResults(
                                            heartAssessment.assessment![currentDisplaySection].id!,
                                            qId,
                                            selectedOption);
                                        },
                                      score: getExistingScore(heartAssessment, question)
                                  ),
                                )
                        ).toList(),
                      ),
                    ),
                    SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                            key: ValueKey('HANextDoneButton'),
                            onPressed: () async {
                              if (currentDisplaySection <
                                  (heartAssessment.assessment!.length - 1)) {
                                if (areAllQuestionsInCurrentSectionCompleted(
                                    heartAssessment,
                                    result,
                                    currentDisplaySection)) {
                                  // If User is logged in. Post Score Async
                                  if (await SharedPreferenceHelper().isUserLoggedIn()) {
                                    var userToken = await SharedPreferenceHelper().getUserToken();
                                    postScores(widget.apiClient, createResultObject(heartAssessment) , userToken!);
                                  }
                                  setState(() {
                                    currentDisplaySection++;
                                  });
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.minScrollExtent,
                                      duration: Duration(milliseconds: 10),
                                      curve: Curves.ease);
                                } else {
                                  //Show Attempt questions error
                                  ScaffoldMessenger.of(
                                          _scaffoldKey.currentContext!)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Please answer all the questions.'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              } else {
                                //Ready to submit
                                createResultObject(heartAssessment);
                                showTestDonePopup(heartAssessment,
                                    widget.apiClient, routerDelegate);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                primary: ternaryColor),
                            child: Text(
                                currentDisplaySection <
                                        (heartAssessment.assessment!.length - 1)
                                    ? 'Next'
                                    : 'Done',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)))),
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
                                primary: Colors.white),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ))),
                    SizedBox(height: 34),
                  ]),
                ),
              ]),
            );
          } else if (data.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
          }
          return Transform.scale(
            scale: 0.1,
            child: CircularProgressIndicator(),
          );
        });
  }

  int? getExistingScore(HeartAssessment heartAssessment, Question question) {
    var currentSection = heartAssessment.assessment?[currentDisplaySection];
    var temp = result[currentSection?.id]?[question.id];
    return temp;
  }

  void addOrUpdateResults(String sectionId, String qId, int selectedOption) {
    if (result[sectionId] == null) {
      result[sectionId] = {};
    }
    result[sectionId]![qId] = selectedOption;
    print('Actual Result $result');
  }

  Map<String, Map<String, int>> mapScoreResultToResult(HeartAssessmentResult heartAssessmentResult) {
    print('mapScoreResultToResult');
    Map<String, Map<String, int>> tempMap = {};
    heartAssessmentResult.sections.map((section) {
      Map<String, int> qMap = {};
      section.questions.map((answers) {
        qMap[answers.questionId] = answers.score;
      }).toList();
      tempMap[section.sectionId] = qMap;
    }
    ).toList();
    return tempMap;
  }

  bool areAllQuestionsInCurrentSectionCompleted(HeartAssessment heartAssessment,
      Map<String, Map<String, int>> result, int currentDisplaySection) {
    var sectionId = heartAssessment.assessment![currentDisplaySection].id;
    var questions =
        heartAssessment.assessment![currentDisplaySection].questions;
    var attemptedQuestionAnswers = result[sectionId];
    if (questions != null &&
        attemptedQuestionAnswers != null &&
        (attemptedQuestionAnswers.length == questions.length)) {
      print('All Questions answered');
      return true;
    } else {
      print('Questions incompleted');
      return false;
    }
  }

  HeartAssessmentResult createResultObject(HeartAssessment heartAssessment) {
    List<Section> sectionsList = result
        .map((sectionId, QnAMap) {
          List<Answer> answers = [];
          QnAMap.forEach((qId, weightage) {
            answers.add(Answer(questionId: qId, score: weightage));
          });
          var section = Section(
              sectionId: sectionId,
              sectionType:
                  getSectionTypeFromSectionId(heartAssessment, sectionId)!,
              questions: answers);
          var entry = MapEntry(sectionId, section);
          return entry;
        })
        .values
        .toList();

    var assessmentResult = HeartAssessmentResult(sections: sectionsList, totalSections: heartAssessment.assessment!.length);

    return assessmentResult;
  }

  String? getSectionTypeFromSectionId(
      HeartAssessment heartAssessment, String sectionId) {
    return heartAssessment.assessment!
        .firstWhere((element) => element.id == sectionId)
        .section;
  }

  Future? postScores(ApiClient apiClient,HeartAssessmentResult result, String token) {
    return apiClient.postWithHeaders('assessment/scores', result.toJson(), {
      'Authorization': 'Bearer $token'
    });
  }

  Future<void> showTestDonePopup(HeartAssessment heartAssessment,
      ApiClient apiClient, CharismaRouterDelegate routerDelegate) async {
    var results = createResultObject(heartAssessment);

    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            key: ValueKey('HATestDonePopup'),
            title: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('You did great!'))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('/images/test_complete.png', fit: BoxFit.cover),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 42, right: 42),
                    child: Text(
                      'Now let’s see what we’ve learned about your relationship',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 27),
                SizedBox(
                  height: 39,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 7),
                    child: ElevatedButton(
                        onPressed: () async {
                          String? token =
                              await SharedPreferenceHelper().getUserToken();
                          if (token != null) {
                            print('User token available. Posting scores');
                            setState(() {
                              isLoading = true;
                            });
                            await postScores(apiClient, results, token)
                                ?.then((value) => {
                                      setState(() {
                                        isLoading = false;
                                      }),
                                      print('Success '),
                                      Navigator.pop(context)
                                    })
                                .catchError((error) => {
                                      setState(() {
                                        isLoading = false;
                                      }),
                                      print('Error! '),
                                      ScaffoldMessenger.of(
                                              _scaffoldKey.currentContext!)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'There was an error while submitting the result. Please try again'),
                                        backgroundColor: Colors.red,
                                      )),
                                      Navigator.pop(context)
                                    });
                          } else {
                            print('User token NOT available. === $results');
                            await SharedPreferenceHelper()
                                .setResultsData(results);
                          }

                          routerDelegate.push(HAResultsConfig);
                        },
                        child: Text('Check out the results'),
                        style: ElevatedButton.styleFrom(
                          primary: ternaryColor,
                        )),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          );
        });
  }

  Future<void> showResultsPopup(HeartAssessment heartAssessment) async {
    var results = createResultObject(heartAssessment);
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('Result!'))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: results.sections
                  .map((section) => Text(
                      '${section.sectionType} ${section.questions.fold(0, (previousValue, element) => (previousValue as int) + element.score)}'))
                  .toList(),
            ),
          );
        });
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
