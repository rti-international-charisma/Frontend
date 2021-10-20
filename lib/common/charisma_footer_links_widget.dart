import 'package:charisma/navigation/charisma_parser.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class CharismaFooterLinks extends StatelessWidget {
  CharismaFooterLinks({Key? key}) : super(key: ValueKey('CharismaFooterLinks'));

  static const links = [
    {'text': 'About Us', 'url': AboutUsPath},
    {'text': 'HIV Prevention: PrEP', 'url': HIVPreventionPrepPath},
    {'text': 'Take the relationship quiz', 'url': HALandingPagePath},
    {
      'text': 'Counselling content',
      'links': [
        {
          'text': 'Healthy Relationships',
          'url': CounsellingModuleHealthyRelationshipPath,
        },
        {
          'text': 'Partner Communication',
          'url': CounsellingModulePartnerCommPath,
        },
        {
          'text': 'PrEP Disclosure',
          'url': CounsellingModulePrepUsePath,
        },
        {
          'text': 'Intimate Partner Violence',
          'url': CounsellingModuleIPVPath,
        },
      ]
    },
    {'text': 'Materials for your partner', 'url': MalePartnerInfoPath},
    {'text': 'Access other support', 'url': ReferralsPath},
  ];

  final CharismaParser _parser = CharismaParser();

  Widget renderExpandableFooterLink(
      BuildContext context,
      Map<String, dynamic> linkData,
      int index,
      int parentIndex,
      bool isSubList) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    bool hasSubList = linkData['links'] != null;

    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: ExpandablePanel(
          header: Container(
            height: 50,
            padding: EdgeInsets.only(left: isSubList ? 35 : 20, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8 -
                      (isSubList ? 15 : 0),
                  alignment: Alignment.centerLeft,
                  child: hasSubList
                      ? Text(
                          linkData['text'].toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )
                      : TextButton(
                          style: TextButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.8, 40),
                              alignment: Alignment.centerLeft),
                          child: Text(
                            linkData['text'].toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Future<PageConfiguration> pageConfigFuture =
                                _parser.parseRouteInformation(
                              RouteInformation(
                                location: linkData['url'] as String,
                              ),
                            );

                            pageConfigFuture.then((pageConfig) {
                              return routerDelegate.replace(pageConfig);
                            });
                          },
                          key: ValueKey(
                              'CharismaFooterLink${index != parentIndex ? "$parentIndex." : ""}$index'),
                        ),
                ),
                ExpandableIcon(
                  theme: const ExpandableThemeData(
                    expandIcon: Icons.arrow_forward_ios_outlined,
                    collapseIcon: Icons.arrow_forward_ios_outlined,
                    iconColor: Colors.black,
                    iconRotationAngle: math.pi / 2,
                    iconPadding: EdgeInsets.only(bottom: 0),
                    iconSize: 22,
                  ),
                )
              ],
            ),
          ),
          collapsed: Container(),
          expanded: hasSubList
              ? new ListView.builder(
                  shrinkWrap: true,
                  itemCount: linkData['links'].length,
                  itemBuilder: (BuildContext context, int innerIndex) =>
                      renderExpandableFooterLink(
                    context,
                    linkData['links'][innerIndex],
                    innerIndex,
                    index,
                    true,
                  ),
                )
              : Container(),
          theme: ExpandableThemeData(
            hasIcon: false,
            tapHeaderToExpand: hasSubList,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: links.length,
      itemBuilder: (BuildContext context, int index) =>
          renderExpandableFooterLink(
              context, links[index], index, index, false),
    );
  }
}
