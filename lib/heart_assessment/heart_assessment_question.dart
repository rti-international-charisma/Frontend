
import 'package:charisma/heart_assessment/heart_assessment_questionnaire.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  HeartQuestion heartQuestion;

  int index;

  QuestionWidget(this.index,this.heartQuestion);

  @override
  State<StatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {

  HeartOption? currentSelectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: Column (
            children: [
              Row(
                children: [
                  Text(
                    widget.index.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 13),
                  Flexible(
                    child: Text(
                        widget.heartQuestion.text!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )
                    ),
                  )
                ],
              ),
              Column(
                children: widget.heartQuestion.options!.map((option) =>
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentSelectedOption = option;
                        });
                        print('Tapped ${widget.heartQuestion.text} ${option.text} ${option.weightage}');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 20,top: 16),
                        child: Container(
                          height: 46,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(width: 21),
                              currentSelectedOption == option ? Icon(Icons.radio_button_checked) :Icon(Icons.radio_button_unchecked) ,
                              SizedBox(width: 16),
                              Text(
                                  option.text!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ).toList(),
              )],
          ),
        )
    );
  }
}