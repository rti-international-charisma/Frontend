import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/navigation/back_dispatcher.dart';
import 'package:charisma/navigation/charisma_parser.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

void main() {
  const API_BASEURL = String.fromEnvironment('API_BASEURL',
      defaultValue: 'http://0.0.0.0:5000/api');
  Provider.debugCheckInvalidValueType = null;
  runApp(CharismaApp(ApiClient(http.Client(), API_BASEURL)));
}

class CharismaApp extends StatelessWidget {
  late ApiClient _apiClient;
  late CharismaRouterDelegate _routerDelegate;
  late CharismaParser _parser;
  late CharismaBackButtonDispatcher _backButtonDispatcher;

  CharismaApp(ApiClient apiClient) {
    _apiClient = apiClient;
    _routerDelegate = CharismaRouterDelegate(_apiClient);
    _parser = CharismaParser();
    _backButtonDispatcher = CharismaBackButtonDispatcher(_routerDelegate);

    _routerDelegate.setNewRoutePath(HomePageConfig);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (context) => NetworkImageBuilder()),
          Provider<Future<SharedPreferences>>(
              create: (_) => SharedPreferences.getInstance()),
          Provider<CharismaRouterDelegate>(create: (_) => _routerDelegate),
        ],
        child: MaterialApp.router(
            title: 'Charisma',
            theme: ThemeData(
              scaffoldBackgroundColor: backgroundColor,
              primaryColor: backgroundColor,
              secondaryHeaderColor: secondaryColor,
              backgroundColor: backgroundColor,
              textTheme:
                  Theme.of(context).textTheme.apply(bodyColor: textColor),
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              canvasColor: backgroundColor,
              inputDecorationTheme:
                  Theme.of(context).inputDecorationTheme.copyWith(
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: textColor,
                        ),
                        hintStyle: TextStyle(color: textColor.withOpacity(.6)),
                      ),
            ),
            backButtonDispatcher: _backButtonDispatcher,
            routeInformationParser: _parser,
            routerDelegate: _routerDelegate));
  }
}
