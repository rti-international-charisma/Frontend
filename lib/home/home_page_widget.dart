import 'dart:ui';

import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key, this.title, this.apiClient}) : super(key: key);

  final String title;
  final ApiClient apiClient;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: widget.apiClient.get<Map<String, dynamic>>('/content'),
        builder: (context, data) {
          if (data.hasData) {
            var homeData = data.data;
            return Scaffold(
              appBar: AppBar(
                title: Image.asset('assets/images/charisma_logo.png',
                    fit: BoxFit.cover),
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
                            "${homeData['assets']['heroImage'][0]['url']}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            alignment: Alignment.center,
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
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ]),
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
