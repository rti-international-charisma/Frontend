

import 'package:charisma/heart_assessment/charisma_heart_app_bar.dart';
import 'package:charisma/heart_assessment/heart_assessment_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'heart_assessment_question.dart';

class HeartAssessmentQuestionnaireWidget extends StatelessWidget {

  var heartAssesment = """
  {
  "assessment": [
    {
      "title": "PARTNER ABUSE AND CONTROL",
      "introduction": "How does your partner treat you? Some of these questions might be difficult for you to answer. Please take your time and please respond as honestly and openly as you can.",
      "questions": [
        {
          "text": "question1",
          "description": "",
          "options": [
            {
              "text": "Strongly disagree",
              "weightage": 1
            },
            {
              "text": "Disagree",
              "weightage": 2
            },
            {
              "text": "Neutral",
              "weightage": 3
            },
            {
              "text": "Agree",
              "weightage": 4
            },
            {
              "text": " Agree strongly",
              "weightage": 5
            }
          ]
        },
        {
          "text": "question2",
          "options": [
            {
              "text": "Strongly disagree",
              "weightage": 1
            },
            {
              "text": "Disagree",
              "weightage": 2
            },
            {
              "text": "Neutral",
              "weightage": 3
            },
            {
              "text": "Agree",
              "weightage": 4
            },
            {
              "text": " Agree strongly",
              "weightage": 5
            }
          ]
        }
      ]
    }
  ]
}
  """;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CharismaHEARTAppBar(
          height: 237,
          child: HeartAssessmentAppBar(
            sectionCount: 'Section 1 of 5',
            title: 'Section Title',
            introduction: 'How does your partner treat you? Some of these questions might be difficult for you to answer. Please take your time and please respond as honestly and openly as you can.',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: mapIndexed(getHeartquestions(), (i, question) =>
                        Container(
                          child: QuestionWidget(++i, question as HeartQuestion),
                        )).toList(),
                  ),
                ),
                SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            primary: ternaryColor
                        ),
                        child: Text(
                            'Next',
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
                        onPressed: () {},
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
      ),
    );
  }


  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  List<HeartQuestion> getHeartquestions() => [
    HeartQuestion('Describe your current relationship status', [HeartOption('option1', 1), HeartOption('option2', 2), HeartOption('option3', 3)]),
    HeartQuestion('What was your partner’s reaction when he found out about your PrEP use?', [HeartOption('option1', 1), HeartOption('option2', 2), HeartOption('option3', 3), HeartOption('option4', 4)]),
    HeartQuestion('Changing diapers, giving the children a bath, and feeding the kids is a mother''s responsibility.', [HeartOption('option1', 1), HeartOption('option2', 2)]),
    HeartQuestion('A woman cannot refuse to have sex with her husband or boyfriend.', [HeartOption('option1', 1), HeartOption('option2', 2)]),
  ];
}

class HeartQuestion {
  String? text;
  List<HeartOption>? options;

  HeartQuestion(this.text, this.options);
}

class HeartOption {
  String? text;
  int weightage = 0;

  HeartOption(this.text, this.weightage);

  @override
  int get hashCode => text.hashCode ^ weightage.hashCode;

  @override
  bool operator ==(Object other) {
    return other is HeartOption && other.text == text && other.weightage == weightage;
  }
}