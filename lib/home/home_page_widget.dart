import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_circular_loader_widget.dart';
import 'package:charisma/common/charisma_error_handler_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/heart_assessment/ha_results_widget.dart';
import 'package:charisma/home/hero_image_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
import 'package:charisma/home/home_page_videos_widget.dart';
import 'package:charisma/home/how_charisma_works_widget.dart';
import 'package:charisma/home/partial_assessment_progress_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/firebase.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({
    Key? key,
    this.apiClient,
    this.assetsUrl,
    this.analytics
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;
  final Analytics? analytics;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  Map<String, dynamic> userData = Map();
  final _scrollController = ScrollController();

  scrollToPageBottom() {
    _scrollController.animateTo(1300,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  Widget getGeneralHomePage(BuildContext context, bool isLoggedIn,
      [double assessmentPercentageComplete = 0]) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: widget.apiClient?.get<Map<String, dynamic>?>('/home'),
      builder: (context, data) {
        if (data.hasData) {
          var homeData = data.data as Map<String, dynamic>;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroImageWidget(
                  data: {
                    ...homeData['heroImage'],
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
                    scrollToPageBottom: scrollToPageBottom,
                  )
                else
                  PartialAssessmentProgressWidget(assessmentPercentageComplete),
                SizedBox(
                  height: 30,
                ),
                HomePageVideos(
                  data: homeData['videoSection'],
                  assetsUrl: widget.assetsUrl,
                  isLoggedIn: isLoggedIn,
                ),
              ],
            ),
          );
        } else if (data.hasError) {
          return CharismaErrorHandlerWidget(
            error: data.error as ErrorBody,
          );
        }
        return CharismaCircularLoader();
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

              return CharismaCircularLoader();
            },
          ),
          HAResultsWidget(
            apiClient: widget.apiClient,
            assetsUrl: widget.assetsUrl,
            displayUserGreeting: false,
            analytics: widget.analytics
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double percentage = 0;

    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
          child: Consumer<UserStateModel>(builder: (ctx, userState, child) {
        if (userState.isLoggedIn) {
          return FutureBuilder(
            future: SharedPreferenceHelper().getUserData()?.then((data) async {
              userData = data;

              String? token = await SharedPreferenceHelper().getUserToken();

              return await widget.apiClient?.getScores(token);
            }).then((data) {
              var attemptedSections = (data['sections'] as List).length;
              var totalSections = data['totalSections'];
              if (totalSections == 0) return 0; //boom
              percentage = (attemptedSections / totalSections) * 100;

              return data;
            }),
            builder: (context, data) {
              if (data.hasData) {
                if (percentage == 100) {
                  return getHomePageWithResults(context);
                } else {
                  return getGeneralHomePage(context, true, percentage);
                }
              } else if (data.hasError) {
                return CharismaErrorHandlerWidget(
                  error: data.error as ErrorBody,
                );
              }
              return CharismaCircularLoader();
            },
          );
        } else {
          return getGeneralHomePage(context, false);
        }
      })),
    );
  }
}
