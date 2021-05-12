import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
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
    Map<String, dynamic>? moduleDataForHealthyRelationship;

    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: apiClient
                ?.getCounsellingModuleWithoutScore(moduleName)
                ?.then((moduleData) async {
              moduleDataForHealthyRelationship = await apiClient
                  ?.getCounsellingModuleWithoutScore('healthy_relationship');

              return moduleData;
            }),
            builder: (context, data) {
              if (data.hasData) {
                var moduleData = data.data as Map<String, dynamic>;
                String heroImageUrl = moduleData['heroImage']['imageUrl'];

                return Column(
                  children: [
                    Image.network(
                      "$assetsUrl$heroImageUrl",
                      fit: BoxFit.fill,
                    ),
                    CounsellingModuleWidget(
                        moduleData: moduleDataForHealthyRelationship,
                        assetsUrl: assetsUrl),
                    CounsellingModuleWidget(
                        moduleData: moduleData, assetsUrl: assetsUrl),
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
