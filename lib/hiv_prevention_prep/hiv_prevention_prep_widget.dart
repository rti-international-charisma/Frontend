import 'package:carousel_slider/carousel_slider.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_circular_loader_widget.dart';
import 'package:charisma/common/charisma_error_handler_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import "package:universal_html/html.dart" as html;

class HIVPreventionPrepWidget extends StatelessWidget {
  const HIVPreventionPrepWidget({
    Key? key,
    required this.apiClient,
    required this.assetsUrl,
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;

  Future<dynamic> getPageData() async {
    return apiClient?.get('/content/hiv_prevention_prep');
  }

  Future<dynamic> getLinks() async {
    return apiClient?.get('/referrals?filter=HIV Prevention PrEP Link');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder(
              future: Future.wait([getPageData(), getLinks()]),
              builder: (context, data) {
                if (data.hasData) {
                  var dataList = data.data as List<dynamic>;
                  var pageData = dataList[0] as Map<String, dynamic>;
                  var links = dataList[1] as List<dynamic>;

                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(minHeight: 250),
                        child: Image.network(
                          "$assetsUrl${pageData['heroImage']['imageUrl']}",
                          fit: BoxFit.cover,
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
                          key: ValueKey('HIVPreventionPrepHeroImage'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                pageData['title'],
                                style: TextStyle(
                                    color: infoTextColor, fontSize: 14),
                                key: ValueKey('HIVPreventionPrepPageTitle'),
                              ),
                            ),
                            Html(
                              data: pageData['introduction'],
                              key: (ValueKey('HIVPreventionPrepIntro')),
                            ),
                            Html(
                              data: pageData['description'],
                              key: ValueKey('HIVPreventionPrepDescription'),
                            ),
                            Text(
                              'Check out the links below if you need more information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            CarouselSlider.builder(
                              key: ValueKey('HIVPreventionPrepExternalLinks'),
                              itemCount: links.length,
                              itemBuilder: (context, index, realIndex) =>
                                  Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(4, 4),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            links[index]['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            key: ValueKey(
                                                'HIVPreventionPrepLinkName-$index'),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Image.network(
                                            "$assetsUrl${links[index]['imageUrl']}",
                                            fit: BoxFit.contain,
                                            height: 190,
                                            key: ValueKey(
                                                'HIVPreventionPrepLinkImage-$index'),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TextButton(
                                            key: ValueKey(
                                                'HIVPreventionPrepLinkButton-$index'),
                                            onPressed: () {
                                              html.window.open(
                                                  links[index]
                                                      ['addressAndContactInfo'],
                                                  'new tab');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Colors.black.withOpacity(0.2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Visit Page',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              options: CarouselOptions(
                                height: 300,
                                enableInfiniteScroll: false,
                                viewportFraction: 0.85,
                              ),
                            )
                          ],
                        ),
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
