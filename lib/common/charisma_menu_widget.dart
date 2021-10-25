import 'package:charisma/about_us/about_us_page_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharismaMenuWidget extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    return PopupMenuButton(
        icon: Icon(Icons.view_headline),
        itemBuilder: (BuildContext context) => <PopupMenuEntry> [
          PopupMenuItem(
            value: 'About Us',
            onTap: () => routerDelegate.replace(AboutUsConfig),
            child: Text('About Us',
                style: blackStyle),
          ),
          PopupMenuItem(
            value: 'HIV Prevention: PrEP',
            onTap: () => routerDelegate.replace(HIVPreventionPrepConfig),
            child: Text('HIV Prevention: PrEP', style: blackStyle),
          ),
          PopupMenuItem(
            value: 'Take the relationship quiz',
            onTap: () => routerDelegate.replace(HeartAssessmentQuestionnaireConfig),
            child: Text('Take the relationship quiz',style: blackStyle),
          ),
          PopupMenuItem(
            value: 'Materials for your partner',
            onTap: () => routerDelegate.replace(MalePartnerInfoConfig),
            child: Text('Materials for your partner', style: blackStyle),
          ),
          PopupMenuItem(
            value: 'Access other support',
            onTap: () => routerDelegate.replace(ReferralsConfig),
            child: Text('Access other support', style: blackStyle),
          ),
          PopupMenuItem(
            child: PopupMenuButton(
              child: Text('Counselling content \u{23F5}', style: blackStyle),
              itemBuilder:  (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 'Healthy Relationships',
                  onTap: () => routerDelegate.replace(CounsellingModuleHealthyRelationshipConfig),
                  child: Text('Healthy Relationships',  style: blackStyle),
                ),
                PopupMenuItem(
                    value: 'Partner Communication',
                    onTap: () => routerDelegate.replace(CounsellingModulePartnerCommConfig),
                    child: Text('Partner Communication',  style: blackStyle)),
                PopupMenuItem(
                    value: 'PrEP Disclosure',
                    onTap: () => routerDelegate.replace(CounsellingModulePrepUseConfig),
                    child: Text('PrEP Disclosure',  style: blackStyle)
                ),
                PopupMenuItem(
                    value: 'Intimate Partner Violence',
                    onTap: () => routerDelegate.replace(CounsellingModuleIPVConfig),
                    child: Text('Intimate Partner Violence',  style: blackStyle)
                ),
              ],
            )
          ),
    ]);
  }

}

const TextStyle blackStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,

);
