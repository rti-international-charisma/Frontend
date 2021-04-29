import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class HALandingPageWidget extends StatelessWidget {
  const HALandingPageWidget({Key? key, this.apiClient, this.apiBaseUrl})
      : super(key: key);

  final ApiClient? apiClient;
  final String? apiBaseUrl;

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    return FutureBuilder<Map<String, dynamic>?>(
      future: apiClient?.get('/assessment/intro'),
      builder: (context, data) {
        if (data.hasData) {
          var pageContent = data.data;

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
                          "$apiBaseUrl${pageContent['images'][0]['imageUrl']}",
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
                  routerDelegate.push(HeartAssessmentQuestionnaireConfig);
                },
                child: Text(
                  'Get started',
                  style: TextStyle(color: Colors.white),
                ),
                key: ValueKey('HAGetStarted'),
              ),
            ),
          );
        } else if (data.hasError) {
          return Scaffold(
              body: Center(
            child: Text("Something went wrong"),
          ));
        }

        // Display a loader while waiting for the API response
        return Transform.scale(scale: 0.1, child: CircularProgressIndicator());
      },
    );
  }
}
