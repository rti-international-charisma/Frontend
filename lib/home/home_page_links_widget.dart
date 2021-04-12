import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageLinks extends StatelessWidget {
  const HomePageLinks({Key? key}) : super(key: key);

  static const links = [
    {'text': 'HIV Prevention: PrEP', 'page_config': null},
    {'text': 'Male Partner Information Pack', 'page_config': null},
    {'text': 'Referrals', 'page_config': null},
    {
      'text': 'Take the HEART assessment test',
      'page_config': HeartAssessmentConfig
    },
    {'text': 'Counselling Content', 'page_config': null},
    {'text': 'About Us', 'page_config': null}
  ];

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    return SizedBox(
      height: 300,
      child: new ListView.builder(
        itemCount: links.length,
        itemBuilder: (BuildContext context, int index) => Container(
          height: 50,
          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.centerLeft,
                child: TextButton(
                  child: Text(
                    links[index]['text'].toString(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    key: ValueKey('HomePageLink$index'),
                  ),
                  onPressed: () {
                    routerDelegate
                        .push(links[index]['page_config'] as PageConfiguration);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_outlined),
                onPressed: () {},
                padding: EdgeInsets.only(bottom: 0),
                color: Colors.black.withOpacity(0.8),
                iconSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
