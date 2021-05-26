import 'package:charisma/heart_assessment/heart_assessment_model.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  Question heartQuestion;

  int index;

  var optionSelected;

  int? score;

  QuestionWidget({
      Key? key,
      required this.index,
      required this.heartQuestion,
      this.optionSelected,
      this.score}): super(key: key) {
    score ??= -1;
  }

  @override
  State<StatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  Option? currentSelectedOption;

  @override
  void initState() {
    if (widget.score != -1) {
      currentSelectedOption = widget.heartQuestion.options!.firstWhere((element) =>
          element.weightage == widget.score
      );
    }
  }

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
                                  getSelectedIcon(option),
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

  bool isSelected(Option option) {
    if (currentSelectedOption == null) return false;
    return currentSelectedOption == option;
  }

  Icon getSelectedIcon(Option option) {
    if (currentSelectedOption == null) {
      return Icon(Icons.radio_button_unchecked,
          key: ValueKey('questionSelectedIcon')
      );
    }
    if (isSelected(option)) {
      return Icon(
        Icons.radio_button_checked,
        key: ValueKey('questionSelectedIcon'),
      );
    } else {
      return Icon(Icons.radio_button_unchecked,
          key: ValueKey('questionSelectedIcon')
      );
    }

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
