import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';

class HeartAssessmentAppBar extends StatelessWidget {
  String? sectionCount = "";

  String? title;

  String? introduction;

  var closeTapped;

  String? fieldKey;

  HeartAssessmentAppBar({
    this.fieldKey,
    this.sectionCount,
    this.title,
    this.introduction,
    this.closeTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key(fieldKey!),
        color: ternaryColor,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sectionCount ?? '',
                    style: TextStyle(
                      color: infoTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: closeTapped,
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(title ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(height: 5),
              new Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    introduction ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
