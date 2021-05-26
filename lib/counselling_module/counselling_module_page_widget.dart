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
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: apiClient?.getCounsellingModuleWithoutScore(moduleName),
            builder: (context, data) {
              if (data.hasData) {
                var moduleData = data.data as Map<String, dynamic>;
                String heroImageUrl = moduleData['heroImage']['imageUrl'];

                return Column(
                  children: [
                    Container(
                      color: Colors.yellow,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        "$assetsUrl$heroImageUrl",
                        fit: BoxFit.contain,
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
