

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

  var heartAssessmentResult = {
    "assessment": [
      {
        "id": "c8aca8b8-d22e-4291-b60e-08a878dac42a",
        "section": "PARTNER CONTEXT",
        "introduction": "Think about the partner or partners you have been involved with sexually during the last year.",
        "questions": [
          {
            "id": "53e79da3-d07a-4f13-81af-b09170a52360",
            "text": "Do you have a primary sex partner – a man you have sex with on a regular basis, or who you consider as your main partner?",
            "description": "If yes, please think about that person when you respond.\nIf you do not currently have a primary sex partner, but have had a primary sex partner in the past year, please think about that person when you respond.\nIf you have not had a primary sex partner in the last year, is there another recent partner who has had more “say” or more influence over your ability to use HIV prevention products? If yes, think about that person when you respond.\nIf you have not had a primary sex partner and there is no other partner who influences your use of HIV prevention methods, please think about the sexual partner you have had sex with most recently when you respond.",
            "options": [
              {
                "text": "Current sex partner",
                "weightage": 1
              },
              {
                "text": "Non-current sex partner, from past year",
                "weightage": 2
              },
              {
                "text": "Most influential of other partners",
                "weightage": 3
              },
              {
                "text": "Most recent sexual partner",
                "weightage": 4
              }
            ],
            "positiveNarrative": true
          },
          {
            "id": "1d369bb8-8373-4010-968b-313c11fa1af6",
            "text": "Does your primary partner know that you are taking oral PrEP?",
            "description": "Does your primary partner know that you are taking oral PrEP?",
            "options": [
              {
                "text": "No",
                "weightage": 2
              },
              {
                "text": "Yes",
                "weightage": 1
              },
              {
                "text": "N/A (No primary partner)",
                "weightage": 3
              }
            ],
            "positiveNarrative": true
          },
          {
            "id": "d33111eb-96fb-4a74-8162-dea5850ed4ee",
            "text": "What was your partner’s reaction when he found out about your PrEP use?",
            "description": "What was your partner’s reaction when he found out about your PrEP use?",
            "options": [
              {
                "text": "Supportive",
                "weightage": 1
              },
              {
                "text": "Neutral",
                "weightage": 2
              },
              {
                "text": "Opposed",
                "weightage": 3
              },
              {
                "text": "Don’t know",
                "weightage": 4
              }
            ],
            "positiveNarrative": true
          }
        ]
      },
      {
        "id": "3a9be2a0-ea29-40ee-973c-d183af87996f",
        "section": "TRADITIONAL VALUES",
        "introduction": "This first section is about how do you feel about the kind of roles that men and women should have in their everyday lives.",
        "questions": [
          {
            "id": "61241d26-3afb-47b7-97ce-46df9c1c42bd",
            "text": "A woman should accept her partner's wishes – even when she disagrees - to keep the family together.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          },
          {
            "id": "0008ea62-937a-4dcb-9b01-5e145d82abbd",
            "text": "I only think I am attractive if other people think I am.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          }
        ]
      },
      {
        "id": "d4dc8750-6364-4278-9c2d-2d594347cc7a",
        "section": "PARTNER ABUSE AND CONTROL",
        "introduction": "How does your partner treat you? Some of these questions might be difficult for you to answer. Please take your time and please respond as honestly and openly as you can.",
        "questions": [
          {
            "id": "e2a0f3be-c756-481e-8ac4-9be8fa515708",
            "text": "I can't seem to make good decisions about my life.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          },
          {
            "id": "ac4a70e8-aa40-4ffa-8769-984842d67e95",
            "text": "I do not trust myself to make good decisions about my life.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          }
        ]
      },
      {
        "id": "fafcdc7a-4be6-4cf3-82e5-9ddde66479bf",
        "section": "PARTNER SUPPORT",
        "introduction": "Consider how much or how little support you might receive or have received from the partner you were thinking of in section 1",
        "questions": [
          {
            "id": "15aa0bd9-2022-406f-a6b6-8bc1d70044e7",
            "text": "My partner does what he wants, even if I do not want him to.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          },
          {
            "id": "cabf12cb-4eea-484d-b6c7-f117f0550287",
            "text": "I feel safe in my current relationship.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          }
        ]
      },
      {
        "id": "b4399697-2e38-434b-9e07-94242bb91295",
        "section": "PARTNER ATTITUDE TO HIV PREVENTION",
        "introduction": "How do you think your partner will react to discussing HIV prevention?",
        "questions": [
          {
            "id": "b3454076-f0c7-4f8e-9f4e-89e3997ec6da",
            "text": "I cannot tell my partner about HIV prevention product use because he will become angry.",
            "description": "",
            "options": [
              {
                "text": "Agree Strongly",
                "weightage": 6
              },
              {
                "text": "Strongly disagree",
                "weightage": 1
              },
              {
                "text": "Little",
                "weightage": 4
              },
              {
                "text": "Neutral",
                "weightage": 3
              },
              {
                "text": "Disagree",
                "weightage": 2
              },
              {
                "text": "Agree",
                "weightage": 5
              }
            ],
            "positiveNarrative": true
          }
        ]
      },
      {
        "id": "746ad99f-0ded-4fc9-95a3-162ebe94d616",
        "section": "HIV PREVENTION READINESS",
        "introduction": "How do you feel about using an HIV prevention product – in this case, oral PrEP?",
        "questions": [
          {
            "id": "bedd6c69-459d-4d4e-b017-46fab6b7c7e4",
            "text": "I worry that my partner will think I do not trust him because I am using the product.",
            "description": "",
            "options": [
              {
                "text": "Strongly disagree",
                "weightage": 6
              },
              {
                "text": "Disagree",
                "weightage": 5
              },
              {
                "text": "Neutral",
                "weightage": 4
              },
              {
                "text": "Little",
                "weightage": 3
              },
              {
                "text": "Agree",
                "weightage": 2
              },
              {
                "text": "Agree strongly",
                "weightage": 1
              }
            ],
            "positiveNarrative": false
          },
          {
            "id": "916eaa5a-9431-442a-9119-1efb5375b835",
            "text": "I am nervous to learn what my HIV status is.",
            "description": "",
            "options": [
              {
                "text": "Strongly disagree",
                "weightage": 6
              },
              {
                "text": "Disagree",
                "weightage": 5
              },
              {
                "text": "Neutral",
                "weightage": 4
              },
              {
                "text": "Little",
                "weightage": 3
              },
              {
                "text": "Agree",
                "weightage": 2
              },
              {
                "text": "Agree strongly",
                "weightage": 1
              }
            ],
            "positiveNarrative": false
          },
          {
            "id": "f8af8cb5-7707-4be3-af2a-316ac1143096",
            "text": "I worry that the product will affect my sex life.",
            "description": "",
            "options": [
              {
                "text": "Strongly disagree",
                "weightage": 6
              },
              {
                "text": "Disagree",
                "weightage": 5
              },
              {
                "text": "Neutral",
                "weightage": 4
              },
              {
                "text": "Little",
                "weightage": 3
              },
              {
                "text": "Agree",
                "weightage": 2
              },
              {
                "text": "Agree strongly",
                "weightage": 1
              }
            ],
            "positiveNarrative": false
          }
        ]
      }
    ]
  };

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
                                  showTestDonePopup(heartAssessment);
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
          return Transform.scale(
            scale: 0.1,
            child: CircularProgressIndicator(),
          );
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

  List<Section> createResultObject(HeartAssessment heartAssessment) {
    List<Section> sectionsList = result.map((sectionId, QnAMap) {
      List<Answer> answers = [];
      QnAMap.forEach((qId, weightage) {
        answers.add(Answer(questionId: qId, score: weightage));
      });
      var section = Section(sectionId: sectionId, sectionType: getSectionTypeFromSectionId(heartAssessment, sectionId)!, answers: answers);
      var entry = MapEntry(sectionId, section);
      return entry;
    }).values.toList();

    return sectionsList;

    // print('sectionsList : $sectionsList');
    // var json = HeartAssessmentResult(sections: sectionsList).toJson();
    //
    // print('Result json : $json');
  }

  String? getSectionTypeFromSectionId(HeartAssessment heartAssessment, String sectionId) {
    //TODO: Add Section Type to Section once added from the BE
    return heartAssessment.assessment!.firstWhere((element) => element.id == sectionId).section;
  }

  Future<void> showTestDonePopup(HeartAssessment heartAssessment) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('You did great!'))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('/images/test_complete.png',
                    fit: BoxFit.cover),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 42,right: 42),
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
                    padding: EdgeInsets.only(left: 20, right: 20, top:7),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showResultsPopup(heartAssessment);
                        },
                        child: Text('Check out the results'),
                        style: ElevatedButton.styleFrom(
                          primary: ternaryColor,
                        )
                    ),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          );
        }
    );
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
              children: results.map((section)  =>
                  Text('${section.sectionType} ${section.answers.fold(0, (previousValue, element) => (previousValue as int) + element.score)}')
              ).toList(),
            ),
          );
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