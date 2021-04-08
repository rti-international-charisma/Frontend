
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';

class CharismaParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(RouteInformation routeInformation) async {

    final uri = Uri.parse(routeInformation.location!);
    print("URI : $uri");
    if (uri.pathSegments.isEmpty) {
      return HomePageConfig;
    }

    final path = uri.pathSegments[0];
    print("Path : $path");
    switch (path) {
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
      default:
        return HomePageConfig;
    }
  }
}