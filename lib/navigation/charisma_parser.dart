import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';

class CharismaParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    print("URI : $uri");
    if (uri.pathSegments.isEmpty) {
      return HomePageConfig;
    }

    switch (uri.toString()) {
      case HomePagePath:
        return HomePageConfig;
      case LoginPath:
        return LoginPageConfig;
      case SignUpPath:
        return SignUpConfig;
      case ProfilePath:
        return ProfileConfig;
      case ForgotPasswordPath:
        return ForgotPasswordConfig;
      case HALandingPagePath:
        return HALandingPageConfig;
      case HeartAssessmentQuestionnairePath:
        return HeartAssessmentQuestionnaireConfig;
      case HAResultsPath:
        return HAResultsConfig;
      case AboutUsPath:
        return AboutUsConfig;
      default:
        return HomePageConfig;
    }
  }
}
