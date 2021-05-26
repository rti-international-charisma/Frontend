import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class PartialAssessmentProgressWidget extends StatelessWidget {
  double assessmentPercentageComplete;

  PartialAssessmentProgressWidget(this.assessmentPercentageComplete);

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    return SizedBox(
      height: 240,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'HEART Assessment Score',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      offset: Offset(4.0, 4.0))
                ]),
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'You’ve already completed ${assessmentPercentageComplete.round()}% of the quiz',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(78)),
                    child: LinearProgressIndicator(
                      value: assessmentPercentageComplete / 100,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(progressBarColor),
                      backgroundColor: backgroundColor,
                      minHeight: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 39,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        routerDelegate.push(HALandingPageConfig);
                      },
                      child: Text('Continue quiz!'),
                      style: ElevatedButton.styleFrom(
                        primary: ternaryColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
