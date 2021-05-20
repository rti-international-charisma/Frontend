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
import 'environment.dart' as environment;
import 'constants.dart';

void main() async {

  const env = String.fromEnvironment('IS_PROD', defaultValue: 'stage');
  String apiBaseUrl = environment.variables[env]!['baseUrl'] ?? 'http://0.0.0.0:5000/api';
  String assetsUrl = environment.variables[env]!['assetsUrl'] ?? 'http://chari-loadb-150mi7h76f40q-0c42746b9ba8f8ab.elb.ap-south-1.amazonaws.com:8055';
  print('Starting App with API_BASEURL : $apiBaseUrl and ASSETS_URL: $assetsUrl');

  Provider.debugCheckInvalidValueType = null;
  runApp(CharismaApp(
      ApiClient(http.Client(), apiBaseUrl), apiBaseUrl, assetsUrl));
}

class CharismaApp extends StatelessWidget {
  late ApiClient _apiClient;
  late String _apiBaseUrl;
  late String _assetsUrl;
  late CharismaRouterDelegate _routerDelegate;
  late CharismaParser _parser;
  late CharismaBackButtonDispatcher _backButtonDispatcher;

  CharismaApp(ApiClient apiClient, String apiBaseUrl, String assetsUrl) {
    _apiClient = apiClient;
    _apiBaseUrl = apiBaseUrl;
    _assetsUrl = assetsUrl;
    _routerDelegate = CharismaRouterDelegate(
      _apiClient,
      _apiBaseUrl,
      _assetsUrl,
    );
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
