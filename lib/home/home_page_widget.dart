import 'dart:ui';

import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key, this.apiClient}) : super(key: key);

  final ApiClient? apiClient;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: widget.apiClient!.get<Map<String, dynamic>>('/content'),
        builder: (context, data) {
          if (data.hasData) {
            var homeData = data.data;

            return Scaffold(
              appBar: AppBar(
                title: Image.asset('assets/images/charisma_logo.png',
                    key: ValueKey('CharismaLogo'), fit: BoxFit.cover),
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                actions: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'Login',
                        key: ValueKey('LoginLink'),
                        style: TextStyle(color: Color(0xff2DA4FA)),
                      ))
                ],
              ),
              body: SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Stack(children: <Widget>[
                          new Image.network(
                            "${homeData!['assets']['heroImage'][0]['url']}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            alignment: Alignment.center,
                            key: ValueKey('HeroImage'),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(20),
                              child: Text(
                                  homeData['textContent']['heroImageText'],
                                  key: ValueKey('HeroImageText'),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ]),
                        SizedBox(
                          height: 40,
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(20),
                              child: Text(
                                homeData['textContent']['howCharismaWorks'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Stack(
                                  children: [
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][0]['url']}",
                                    ),
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][1]['url']}",
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 30,
                                      child: Text(
                                        '1',
                                        key: ValueKey('Step1'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "${homeData['textContent']['step1']}",
                                    key: ValueKey('Step1Text'),
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'Lato'),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Stack(
                                  children: [
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][2]['url']}",
                                    ),
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][3]['url']}",
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 30,
                                      child: Text(
                                        '2',
                                        key: ValueKey('Step2'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "${homeData['textContent']['step2']}",
                                    key: ValueKey('Step2Text'),
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'Lato'),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Stack(
                                  children: [
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][4]['url']}",
                                    ),
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][5]['url']}",
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 30,
                                      child: Text(
                                        '3',
                                        key: ValueKey('Step3'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "${homeData['textContent']['step3']}",
                                    key: ValueKey('Step3Text'),
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'Lato'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Stack(
                                  children: [
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][6]['url']}",
                                    ),
                                    new Image.network(
                                      "${homeData['assets']['stepImage'][7]['url']}",
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 30,
                                      child: Text(
                                        '4',
                                        key: ValueKey('Step4'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${homeData['textContent']['step4']}",
                                      key: ValueKey('Step4Text'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: 'Lato'),
                                    ),
                                    Text(
                                      "${homeData['textContent']['step4SubText']}",
                                      key: ValueKey('Step4SubText'),
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: 'Roboto'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        )
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
