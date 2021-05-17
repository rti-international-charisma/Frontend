import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/heart_assessment/ha_results_widget.dart';
import 'package:flutter/material.dart';

class HAResultsPageWidget extends StatelessWidget {
  const HAResultsPageWidget({Key? key, this.apiClient, this.assetsUrl})
      : super(key: key);

  final ApiClient? apiClient;
  final String? assetsUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharismaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: HAResultsWidget(
            apiClient: apiClient,
            assetsUrl: assetsUrl,
            displayUserGreeting: true,
          ),
        ),
      ),
    );
  }
}
