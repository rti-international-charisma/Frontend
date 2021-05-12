import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/home/hero_image_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
import 'package:charisma/home/home_page_videos_widget.dart';
import 'package:charisma/home/how_charisma_works_widget.dart';

import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({
    Key? key,
    this.apiClient,
    this.assetsUrl,
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  Map<String, dynamic> userData = Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: widget.apiClient?.get<Map<String, dynamic>?>('/home'),
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
                        assetsUrl: widget.assetsUrl,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      HowCharismaWorks(
                        data: homeData['steps'],
                        assetsUrl: widget.assetsUrl,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      HomePageVideos(
                        data: homeData['videoSection'],
                        assetsUrl: widget.assetsUrl,
                      ),
                      CharismaFooterLinks()
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
