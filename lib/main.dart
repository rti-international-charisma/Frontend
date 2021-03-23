import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'home/home_page_widget.dart';

void main() {
  const API_BASEURL = String.fromEnvironment('API_BASEURL',
      defaultValue: 'http://0.0.0.0:5000');
  runApp(CharismaApp(ApiClient(http.Client(), API_BASEURL)));
}

class CharismaApp extends StatelessWidget {
  final ApiClient _apiClient;

  const CharismaApp(this._apiClient);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (context) => NetworkImageBuilder()),
          Provider<Future<SharedPreferences>>(
              create: (_) => SharedPreferences.getInstance()),
        ],
        child: MaterialApp(
          title: 'Charisma',
          theme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            primaryColor: backgroundColor,
            secondaryHeaderColor: secondaryColor,
            backgroundColor: backgroundColor,
            textTheme: Theme.of(context).textTheme.apply(bodyColor: textColor),
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
          home: HomePageWidget(apiClient: _apiClient),
        ));
  }
}
