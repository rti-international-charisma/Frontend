import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class Utils {
  static const apiBaseUrl = 'http://0.0.0.0:5000/api';
  static const assetsUrl =
      'http://chari-loadb-150mi7h76f40q-0c42746b9ba8f8ab.elb.ap-south-1.amazonaws.com:8055';
}

class MockNetworkImageBuilder implements NetworkImageBuilder {
  @override
  Image build(String imageUrl) {
    return Image.asset('assets/images/rti_logo.png');
  }
}

class MockSharedPreferencesHelper extends Mock
    implements SharedPreferenceHelper {}

class MockApiClient extends Mock implements ApiClient {}

class MockRouterDelegate extends Mock implements CharismaRouterDelegate {}

extension MaterialWrap on Widget {
  static const apiBaseUrl = 'http://0.0.0.0:5000/api';
  static const assetsUrl =
      'http://chari-loadb-150mi7h76f40q-0c42746b9ba8f8ab.elb.ap-south-1.amazonaws.com:8055';

  Widget wrapWithMaterial() => MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (ctx) => MockNetworkImageBuilder()),
          Provider<Future<SharedPreferences>>(
              create: (_) => SharedPreferences.getInstance()),
          ChangeNotifierProvider(create: (context) => UserStateModel()),
          InheritedProvider<CharismaRouterDelegate>(
            create: (ctx) => CharismaRouterDelegate(
              MockApiClient(),
              Utils.apiBaseUrl,
              Utils.assetsUrl,
            ),
          )
        ],
        child: MaterialApp(
            home: Scaffold(
          body: this,
        )),
      );

  Widget wrapWithMaterialAndUserState(UserStateModel userStateModel) =>
      MultiProvider(
        providers: [
          Provider<NetworkImageBuilder>(
              create: (ctx) => MockNetworkImageBuilder()),
          Provider<Future<SharedPreferences>>(
              create: (_) => SharedPreferences.getInstance()),
          ChangeNotifierProvider(create: (context) => userStateModel),
          InheritedProvider<CharismaRouterDelegate>(
            create: (ctx) => CharismaRouterDelegate(
              MockApiClient(),
              Utils.apiBaseUrl,
              Utils.assetsUrl,
            ),
          )
        ],
        child: MaterialApp(
            home: Scaffold(
          body: this,
        )),
      );

  Widget wrapWithMaterialMockRouter(MockRouterDelegate routerDelegate) =>
      MultiProvider(
        providers: [
          InheritedProvider<CharismaRouterDelegate>(
              create: (ctx) => routerDelegate),
          ChangeNotifierProvider(create: (context) => UserStateModel()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: this,
          ),
        ),
      );

  Widget wrapWithMaterialMockRouterUserState(
          MockRouterDelegate routerDelegate, UserStateModel userStateModel) =>
      MultiProvider(
        providers: [
          InheritedProvider<CharismaRouterDelegate>(
              create: (ctx) => routerDelegate),
          ChangeNotifierProvider(create: (context) => userStateModel),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: this,
          ),
        ),
      );
}
