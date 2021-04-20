import 'dart:ui';

import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/home/hero_image_widget.dart';
import 'package:charisma/home/home_page_links_widget.dart';
import 'package:charisma/home/home_page_videos_widget.dart';
import 'package:charisma/home/how_charisma_works_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key, this.apiClient, this.apiBaseUrl}) : super(key: key);

  final ApiClient? apiClient;
  final String? apiBaseUrl;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  Map<String, dynamic> userData = Map();

  Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs =
        await Provider.of<Future<SharedPreferences>>(context);
    var userDataEncoded = prefs.getString('userData');

    if (userDataEncoded == null) {
      return null;
    } else {
      userData = convert.jsonDecode(userDataEncoded);
      return userData['user'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: Container(
          child: Image.asset(
            'assets/images/charisma_logo.png',
            key: ValueKey('CharismaLogo'),
            fit: BoxFit.scaleDown,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(),
            builder: (context, data) {
              if (data.hasData) {
                var userData = data.data;

                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(10, 10, 30, 10),
                  child: Text(
                    'Hi ${userData!['username']}!',
                    style: TextStyle(
                      color: Color(0xff2DA4FA),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    key: ValueKey('UserName'),
                  ),
                );
              }

              return Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: TextButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xff2DA4FA),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      key: ValueKey('SignUpLink'),
                      onPressed: () {
                        routerDelegate.push(SignUpConfig);
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '|',
                      style: TextStyle(color: Color(0xff929292), fontSize: 14),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: TextButton(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xff2DA4FA),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      key: ValueKey('LoginLink'),
                      onPressed: () {
                        routerDelegate.push(LoginPageConfig);
                      },
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: widget.apiClient?.get<Map<String, dynamic>>('/home'),
          builder: (context, data) {
            if (data.hasData) {
              var homeData = data.data;
              return Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      HeroImageWidget(
                        data: homeData!['heroImage'],
                        apiBaseUrl: widget.apiBaseUrl,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      HowCharismaWorks(
                        data: homeData['steps'],
                        apiBaseUrl: widget.apiBaseUrl,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      HomePageVideos(
                        data: homeData['videoSection'],
                        apiBaseUrl: widget.apiBaseUrl,
                        isUserLoggedIn: userData.isNotEmpty,
                      ),
                      HomePageLinks()
                    ],
                  ),
                ),
              );
            } else if (data.hasError) {
              return Scaffold(
                  body: Center(
                child: Text(
                    "Oops! Looks like something went wrong. Please try again later."),
              ));
            }
            return Transform.scale(
              scale: 0.1,
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
