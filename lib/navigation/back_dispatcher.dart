
import 'package:charisma/navigation/router_delegate.dart';
import 'package:flutter/material.dart';

class CharismaBackButtonDispatcher extends RootBackButtonDispatcher {
  final CharismaRouterDelegate _routerDelegate;

  CharismaBackButtonDispatcher(this._routerDelegate): super();

  @override
  Future<bool> didPopRoute() {
    return _routerDelegate.popRoute();
  }
}