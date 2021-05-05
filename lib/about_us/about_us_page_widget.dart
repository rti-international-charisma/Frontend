import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({
    Key? key,
    this.apiClient,
    this.assetsUrl,
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: apiClient?.get<Map<String, dynamic>?>('/aboutus'),
          builder: (context, data) {
            if (data.hasData) {
              var aboutUsData = data.data;

              return SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          child: new Image.network(
                            "$assetsUrl${aboutUsData!['images'][1]['imageUrl']}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            alignment: Alignment.center,
                            key: ValueKey('AboutUsHeadlineImage'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Text(
                            aboutUsData['title'],
                            style: TextStyle(
                              color: infoTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            key: ValueKey('AboutUsTitle'),
                          ),
                        ),
                        Html(
                          data: aboutUsData['introduction'],
                          key: ValueKey('AboutUsIntro'),
                          style: {
                            'body': Style(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            )
                          },
                        ),
                        Html(
                          data: aboutUsData['description'],
                          key: ValueKey('AboutUsDescription'),
                          style: {'body': Style(padding: EdgeInsets.all(10))},
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            aboutUsData['images'][0]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            key: ValueKey('AboutUsHEARTTitle'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: new Image.network(
                            "$assetsUrl${aboutUsData['images'][0]['imageUrl']}",
                            fit: BoxFit.contain,
                            width: double.infinity,
                            alignment: Alignment.center,
                            key: ValueKey('AboutUsHEARTImage'),
                          ),
                        ),
                        Html(
                          data: aboutUsData['summary'],
                          key: ValueKey('AboutUsSummary'),
                          style: {
                            'body': Style(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10))
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (data.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                      "Oops! Looks like something went wrong. Please try again later."),
                ),
              );
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
