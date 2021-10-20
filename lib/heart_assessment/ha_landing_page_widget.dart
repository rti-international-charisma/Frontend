import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_circular_loader_widget.dart';
import 'package:charisma/common/charisma_error_handler_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class HALandingPageWidget extends StatelessWidget {
  const HALandingPageWidget({
    Key? key,
    this.apiClient,
    this.apiBaseUrl,
    this.assetsUrl,
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? apiBaseUrl;
  final String? assetsUrl;

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    return FutureBuilder(
      future: Future.wait([getIntro(), getScores()]),
      builder: (context, data) {
        if (data.hasData) {
          var pageContent = (data.data as List)[0];
          var scoresData = (data.data as List)[1];
          var partiallyComplete = isPartiallyComplete(scoresData);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff244E74),
              toolbarHeight: 80,
              flexibleSpace: Padding(
                padding: EdgeInsets.fromLTRB(50, 20, 30, 0),
                child: Text(
                  pageContent!['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  key: ValueKey('HAPageTitle'),
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 40),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Html(
                        data: pageContent['introduction'],
                        key: ValueKey('HAIntro'),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: new Image.network(
                          "$assetsUrl${pageContent['images'][0]['imageUrl']}",
                          fit: BoxFit.contain,
                          width: double.infinity,
                          alignment: Alignment.center,
                          key: ValueKey('HAIntroImage'),
                        ),
                      ),
                      Html(
                        data: pageContent['summary'],
                        key: ValueKey('HASummary'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: Container(
              color: Color(0xff244E74),
              width: double.infinity,
              height: 40,
              child: TextButton(
                onPressed: () {
                  routerDelegate.replace(HeartAssessmentQuestionnaireConfig);
                },
                child: Text(
                  partiallyComplete ? 'Continue' : 'Get started',
                  style: TextStyle(color: Colors.white),
                ),
                key: ValueKey('HAGetStarted'),
              ),
            ),
          );
        } else if (data.hasError) {
          return CharismaErrorHandlerWidget(
            error: data.error as ErrorBody,
          );
        }

        // Display a loader while waiting for the API response
        return CharismaCircularLoader();
      },
    );
  }

  Future<dynamic> getScores() async {
    String? userToken = await SharedPreferenceHelper().getUserToken();
    if (userToken != null) {
      return await apiClient!.getScores(userToken);
    } else {
      return Future.value(null);
    }
  }

  Future<dynamic> getIntro() async {
    return await apiClient?.get('/content/assessment-intro');
  }

  isPartiallyComplete(scoresData) {
    if (scoresData == null) return false;
    var attemptedSections = (scoresData['sections'] as List).length;
    var totalSections = scoresData['totalSections'];
    if (attemptedSections == 0) return false;
    return attemptedSections < totalSections;
  }
}
