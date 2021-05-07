import 'package:charisma/navigation/charisma_parser.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageLinks extends StatelessWidget {
  HomePageLinks({Key? key}) : super(key: key);

  static const links = [
    {'text': 'HIV Prevention: PrEP', 'url': null},
    {'text': 'Male Partner Information Pack', 'url': null},
    {'text': 'Referrals', 'url': null},
    {'text': 'Take the HEART assessment test', 'url': HALandingPagePath},
    {'text': 'Counselling Content', 'url': null},
    {'text': 'About Us', 'url': AboutUsPath}
  ];

  final CharismaParser _parser = CharismaParser();

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
                  style: TextButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 40),
                      alignment: Alignment.centerLeft),
                  child: Text(
                    links[index]['text'].toString(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    key: ValueKey('HomePageLink$index'),
                  ),
                  onPressed: () {
                    Future<PageConfiguration> pageConfigFuture =
                        _parser.parseRouteInformation(
                      RouteInformation(
                        location: links[index]['url'] as String,
                      ),
                    );

                    pageConfigFuture.then((pageConfig) {
                      return routerDelegate.push(pageConfig);
                    });
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
