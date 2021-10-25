import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_circular_loader_widget.dart';
import 'package:charisma/common/charisma_error_handler_widget.dart';
import 'package:charisma/common/charisma_footer_links_widget.dart';
import 'package:charisma/counselling_module/counselling_module_widget.dart';
import 'package:flutter/material.dart';

class CounsellingModulePageWidget extends StatelessWidget {
  const CounsellingModulePageWidget({
    Key? key,
    @required this.apiClient,
    @required this.moduleName,
    @required this.assetsUrl,
  }) : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;
  final String? moduleName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            FutureBuilder(
              future: apiClient?.getCounsellingModuleWithoutScore(moduleName),
              builder: (context, data) {
                if (data.hasData) {
                  var moduleData = data.data as Map<String, dynamic>;
                  String heroImageUrl = moduleData['heroImage']['imageUrl'];

                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(minHeight: 180),
                        child: Image.network(
                          "$assetsUrl$heroImageUrl",
                          fit: BoxFit.contain,
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
                          key: ValueKey('HeroImage'),
                        ),
                      ),
                      CounsellingModuleWidget(
                        moduleData: moduleData,
                        assetsUrl: assetsUrl,
                        key: ValueKey('PageCounsellingModule'),
                      ),
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
