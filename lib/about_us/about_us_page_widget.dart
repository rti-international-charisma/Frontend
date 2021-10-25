import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_circular_loader_widget.dart';
import 'package:charisma/common/charisma_error_handler_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
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
        child: ListView(
          children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: apiClient?.get<Map<String, dynamic>?>('/content/aboutus'),
              builder: (context, data) {
                if (data.hasData) {
                  var aboutUsData = data.data;

                  return Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: 250),
                        child: new Image.network(
                          "$assetsUrl${aboutUsData!['images'][0]['imageUrl']}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          alignment: Alignment.center,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
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
                      if (aboutUsData['images'].length == 2)
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            aboutUsData['images'][1]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            key: ValueKey('AboutUsHEARTTitle'),
                          ),
                        ),
                      if (aboutUsData['images'].length == 2)
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: new Image.network(
                            "$assetsUrl${aboutUsData['images'][1]['imageUrl']}",
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 300,
                            alignment: Alignment.center,
                            key: ValueKey('AboutUsHEARTImage'),
                          ),
                        ),
                      Html(
                        data: aboutUsData['summary'],
                        key: ValueKey('AboutUsSummary'),
                        style: {
                          'body':
                              Style(padding: EdgeInsets.fromLTRB(10, 0, 10, 10))
                        },
                      )
                    ],
                  );
                } else if (data.hasError) {
                  return CharismaErrorHandlerWidget(
                    error: data.error as ErrorBody,
                  );
                }

                return CharismaCircularLoader();
              },
            ),
          ],
        ),
      ),
    );
  }
}
