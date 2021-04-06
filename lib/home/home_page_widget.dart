import 'dart:ui';

import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/home/hero_image_widget.dart';
import 'package:charisma/home/home_page_videos_widget.dart';
import 'package:charisma/home/how_charisma_works_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key, this.apiClient}) : super(key: key);

  final ApiClient? apiClient;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  static const apiBaseUrl = String.fromEnvironment('API_BASEURL',
      defaultValue: 'http://0.0.0.0:5000');

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    return FutureBuilder<Map<String, dynamic>?>(
        future: widget.apiClient?.get<Map<String, dynamic>>('/homepage'),
        builder: (context, data) {
          if (data.hasData) {
            var homeData = data.data!['data'];

            return Scaffold(
              appBar: AppBar(
                title: Image.asset('assets/images/charisma_logo.png',
                    key: ValueKey('CharismaLogo'), fit: BoxFit.cover),
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: TextButton(
                      child: Text("Login"),
                      key: ValueKey('LoginLink'),
                      onPressed: () {
                        routerDelegate.push(SignUpConfig);
                      },
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        HeroImageWidget(
                          data: homeData,
                          apiBaseUrl: apiBaseUrl,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        HowCharismaWorks(
                          data: homeData,
                          apiBaseUrl: apiBaseUrl,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        HomePageVideos(
                          data: homeData,
                          apiBaseUrl: apiBaseUrl,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (data.hasError) {
            return Scaffold(
                body: Center(
              child: Text("Something went wrong"),
            ));
          }
          return Transform.scale(
              scale: 0.1, child: CircularProgressIndicator());
        });
  }
}
