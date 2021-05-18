import 'package:charisma/constants.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class CharismaExpandableWidget extends StatelessWidget {
  const CharismaExpandableWidget(
      {Key? key, required this.data, required this.assetsUrl})
      : super(key: key);

  final Map<String, dynamic> data;
  final String? assetsUrl;

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
                        data['title'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        key: ValueKey('CharismaExpandableTitle'),
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
              expanded: Column(
                children: [
                  if (data['imageUrl'] != null)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Image.network(
                        "$assetsUrl${data['imageUrl']}",
                        fit: BoxFit.contain,
                        key: ValueKey('CharismaExpandableImage'),
                      ),
                    ),
                  Html(
                    data: data['description'],
                    style: {
                      'body': Style(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      ),
                    },
                    key: ValueKey('CharismaExpandableDescription'),
                  ),
                ],
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
