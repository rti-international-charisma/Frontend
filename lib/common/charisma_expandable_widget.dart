import 'package:charisma/constants.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class CharismaExpandableWidget extends StatelessWidget {
  const CharismaExpandableWidget(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            child: ExpandablePanel(
              header: Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ternaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ExpandableIcon(
                      theme: const ExpandableThemeData(
                        expandIcon: Icons.expand_more,
                        collapseIcon: Icons.expand_more,
                        iconColor: Colors.white,
                        iconSize: 28.0,
                        iconRotationAngle: -math.pi,
                        iconPadding: EdgeInsets.only(right: 5),
                        hasIcon: false,
                      ),
                    ),
                  ],
                ),
              ),
              collapsed: Container(),
              expanded: Html(
                data: description,
                style: {
                  'body': Style(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                },
              ),
              theme: ExpandableThemeData(
                hasIcon: false,
                tapBodyToCollapse: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
