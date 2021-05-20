import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import "package:collection/collection.dart";
import 'package:flutter_html/style.dart';

class ReferralsWidget extends StatelessWidget {
  const ReferralsWidget({
    Key? key,
    required this.apiClient,
    required this.assetsUrl,
  }) : super(key: key);

  final ApiClient apiClient;
  final String? assetsUrl;

  Future<dynamic> getReferralPage() async {
    return apiClient.get('/content/referral_intro');
  }

  Future<dynamic> getReferralsList() async {
    return apiClient.get('/referrals');
  }

  List<Widget> getReferralsWidgetList(List<dynamic> referralsList) {
    var referralsGroupedList = groupBy(referralsList,
        (referralData) => (referralData as Map<String, dynamic>)['type']);

    List<Widget> referralsWidgetList = <Widget>[];

    referralsGroupedList.entries.forEach((element) {
      int totalReferrals = element.value.length;

      referralsWidgetList.add(CharismaExpandableWidget(
        data: {'title': element.key},
        assetsUrl: assetsUrl,
        widgetContent: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
          padding: EdgeInsets.all(5),
          children: List.generate(
            totalReferrals,
            (index) {
              var referralData = element.value[index] as Map<String, dynamic>;

              return Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    Image.network(
                      "$assetsUrl${referralData['imageUrl']}",
                      fit: BoxFit.contain,
                      width: 70,
                      height: 70,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        referralData['name'],
                        style: TextStyle(
                            color: ternaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Html(
                      data: referralData['addressAndContactInfo'],
                      style: {
                        'body': Style(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.all(0))
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ));
    });

    return referralsWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([getReferralPage(), getReferralsList()]),
            builder: (context, data) {
              if (data.hasData) {
                var dataList = data.data as List<dynamic>;

                var referralsPage = dataList[0] as Map<String, dynamic>;
                var referralsList = dataList[1] as List<dynamic>;

                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        "$assetsUrl${referralsPage['heroImage']['imageUrl']}",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              referralsPage['title'],
                              style:
                                  TextStyle(fontSize: 14, color: infoTextColor),
                            ),
                          ),
                          Html(data: referralsPage['introduction']),
                          ...getReferralsWidgetList(referralsList)
                        ],
                      ),
                    )
                  ],
                );
              }
              return Transform.scale(
                scale: 0.1,
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
