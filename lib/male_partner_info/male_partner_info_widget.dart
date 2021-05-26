import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import "package:universal_html/html.dart" as html;

class MalePartnerInfoWidget extends StatelessWidget {
  const MalePartnerInfoWidget({
    Key? key,
    required this.apiClient,
    required this.assetsUrl,
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;

  String getListOfDocuments(List<dynamic> documents) {
    String list = '<ul>';

    documents.forEach((document) {
      list +=
          '<li><a title="${document["title"]}" href="$assetsUrl${document["documentUrl"]}" target="_blank" rel="noopener">${document["title"]}</a></li>';
    });

    return list += '</ul>';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: apiClient?.get('/content/male_partner_info_pack'),
            builder: (context, data) {
              if (data.hasData) {
                var pageData = data.data as Map<String, dynamic>;
                var documents = pageData['documents'] as List<dynamic>;

                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        "$assetsUrl${pageData['heroImage']['imageUrl']}",
                        fit: BoxFit.contain,
                        key: ValueKey('MalePartnerInfoHeroImage'),
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
                              style:
                                  TextStyle(color: infoTextColor, fontSize: 14),
                              key: ValueKey('MalePartnerInfoPageTitle'),
                            ),
                          ),
                          Html(
                            data: pageData['introduction'],
                            onLinkTap: (String? url,
                                RenderContext context,
                                Map<String, String> attributes,
                                dom.Element? element) {
                              html.window.open(url as String, 'new tab');
                            },
                            style: {
                              'a': Style(
                                textDecoration: TextDecoration.none,
                              )
                            },
                            key: ValueKey('MalePartnerInfoIntro'),
                          ),
                          Html(
                            data: pageData['description'],
                            key: ValueKey('MalePartnerInfoDescription'),
                          ),
                          Html(
                            data: getListOfDocuments(documents),
                            onLinkTap: (String? url,
                                RenderContext context,
                                Map<String, String> attributes,
                                dom.Element? element) {
                              html.window.open(url as String, 'new tab');
                            },
                            style: {
                              'li': Style(
                                  margin: EdgeInsets.symmetric(vertical: 15)),
                              'a': Style(
                                textDecoration: TextDecoration.none,
                              )
                            },
                            key: ValueKey('MalePartnerInfoDocuments'),
                          ),
                        ],
                      ),
                    ),
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
