import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_circular_loader_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder(
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
                                style: TextStyle(
                                    color: infoTextColor, fontSize: 14),
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
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: documents.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  InkWell(
                                onTap: () {
                                  html.window.open(
                                      "$assetsUrl${documents[index]['documentUrl']}",
                                      'new tab');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    key: ValueKey('MalePartnerInfoDocuments'),
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.circle,
                                          size: 5,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Text(
                                          documents[index]['title'],
                                          key: ValueKey(
                                              'MalePartnerInfoDoc-$index'),
                                        ),
                                      ),
                                      Icon(
                                        Icons.picture_as_pdf_outlined,
                                        color: linkColor,
                                        size: 20,
                                      ),
                                      Icon(
                                        Icons.link,
                                        color: linkColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return CharismaCircularLoader();
              },
            ),
            CharismaFooterLinks(),
          ],
        ),
      ),
    );
  }
}
