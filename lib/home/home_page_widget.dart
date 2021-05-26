import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/heart_assessment/ha_results_widget.dart';
import 'package:charisma/home/hero_image_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
import 'package:charisma/home/home_page_videos_widget.dart';
import 'package:charisma/home/how_charisma_works_widget.dart';
import 'package:charisma/home/partial_assessment_progress_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget getGeneralHomePage(BuildContext context, bool isLoggedIn,
      [double assessmentPercentageComplete = 0]) {
    return FutureBuilder<Map<String, dynamic>?>(
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
                    data: {
                      ...homeData!['heroImage'],
                      'heroImageCaptionTestIncomplete':
                          homeData['heroImageCaptionTestIncomplete'],
                    },
                    userGreeting: isLoggedIn
                        ? '<h2>Welcome back, ${userData['username']}!</h2>'
                        : null,
                    assetsUrl: widget.assetsUrl,
                    isTestComplete:
                        assessmentPercentageComplete == 0 ? null : false,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if (assessmentPercentageComplete == 0)
                    HowCharismaWorks(
                      data: homeData['steps'],
                      assetsUrl: widget.assetsUrl,
                    )
                  else
                    PartialAssessmentProgressWidget(
                        assessmentPercentageComplete),
                  SizedBox(
                    height: 30,
                  ),
                  HomePageVideos(
                    data: homeData['videoSection'],
                    assetsUrl: widget.assetsUrl,
                    isLoggedIn: isLoggedIn,
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
    );
  }

  Widget getHomePageWithResults(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          FutureBuilder(
            future: widget.apiClient?.get<Map<String, dynamic>?>('/home'),
            builder: (context, data) {
              if (data.hasData) {
                var homeData = data.data as Map<String, dynamic>;

                return HeroImageWidget(
                  data: {
                    ...homeData['heroImage'],
                    'heroImageCaptionTestComplete':
                        homeData['heroImageCaptionTestComplete'],
                  },
                  isTestComplete: true,
                  userGreeting:
                      '<h2>Welcome back, ${userData['username']}!</h2>',
                  assetsUrl: widget.assetsUrl,
                );
              }

              return Transform.scale(
                scale: 0.1,
                child: CircularProgressIndicator(),
              );
            },
          ),
          HAResultsWidget(
            apiClient: widget.apiClient,
            assetsUrl: widget.assetsUrl,
            displayUserGreeting: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
          child: Consumer<UserStateModel>(builder: (ctx, userState, child) {
        if (userState.isLoggedIn) {
          return FutureBuilder<double>(
            future: SharedPreferenceHelper().getUserData()?.then((data) async {
              userData = data;

              String? token = await SharedPreferenceHelper().getUserToken();

              return await widget.apiClient?.getScores(token);
            }).then((value) {
              var attemptedSections = (value['sections'] as List).length;
              var totalSections = value['totalSections'];
              if (totalSections == 0) return 0; //boom
              return (attemptedSections / totalSections) * 100;
            }),
            builder: (context, percentage) {
              if (percentage.hasData) {
                if (percentage.data == 100) {
                  return getHomePageWithResults(context);
                } else {
                  return getGeneralHomePage(context, true, percentage.data!);
                }
              } else if (percentage.hasError) {
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
          );
        } else {
          return getGeneralHomePage(context, false);
        }
      })),
    );
  }
}
