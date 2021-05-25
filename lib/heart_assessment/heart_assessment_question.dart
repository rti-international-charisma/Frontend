import 'package:charisma/heart_assessment/heart_assessment_model.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  Question heartQuestion;

  int index;

  var optionSelected;

  QuestionWidget(this.index, this.heartQuestion, this.optionSelected);

  @override
  State<StatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  Option? currentSelectedOption;

  @override
  Widget build(BuildContext context) {
    sortOptions();
    return Container(
        key: ValueKey('HAQuestion_${widget.index}'),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.index.toString(),
                    key: ValueKey('questionIndex'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 13),
                  Flexible(
                    child: Text(widget.heartQuestion.text!,
                        key: ValueKey('questionText'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                  )
                ],
              ),
              Column(
                children: widget.heartQuestion.options!
                    .map((option) => GestureDetector(
                          onTap: () {
                            setState(() {
                              currentSelectedOption = option;
                            });
                            widget.optionSelected(widget.heartQuestion.id,
                                currentSelectedOption!.weightage);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, top: 16),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  currentSelectedOption == option
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          key: ValueKey('questionSelectedIcon'),
                                        )
                                      : Icon(
                                          Icons.radio_button_unchecked,
                                          key: ValueKey('questionSelectedIcon'),
                                        ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      option.text!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ));
  }

  void sortOptions() {
    if (widget.heartQuestion.positiveNarrative) {
      widget.heartQuestion.options!.sort((a, b) {
        return a.weightage!.compareTo(b.weightage!);
      });
    } else {
      widget.heartQuestion.options!.sort((a, b) {
        return b.weightage!.compareTo(a.weightage!);
      });
    }
  }
}
