import 'dart:collection';

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {

  final Analytics? analytics;

  AnalyticsRouteObserver({@required this.analytics});

  void _sendPageView(PageRoute<dynamic> route) {
    var pageName = route.settings.name;
    if (null != analytics) {
      analytics!.setCurrentScreen(pageName);
      analytics!.logEvent(pageName!, new HashMap());
    } else {
      print('pageName: $pageName');
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendPageView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendPageView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendPageView(previousRoute);
    }
  }
}