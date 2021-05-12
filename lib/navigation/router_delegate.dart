import 'package:charisma/about_us/about_us_page_widget.dart';
import 'package:charisma/account/forgot_password_widget.dart';
import 'package:charisma/account/set_new_password_widget.dart';
import 'package:charisma/counselling_module/counselling_module_page_widget.dart';
import 'package:charisma/heart_assessment/ha_landing_page_widget.dart';
import 'package:charisma/heart_assessment/heart_assessment_questionnaire.dart';
import 'package:charisma/heart_assessment/ha_results_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:charisma/account/login_page_widget.dart';
import 'package:charisma/account/profile_page_widget.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/home/home_page_widget.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';

import '../account/signup_page_widget.dart';

class CharismaRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<Page> _pages = [];
  late ApiClient _apiClient;
  late String _apiBaseUrl;
  late String _assetsUrl;
  CharismaRouterDelegate(this._apiClient, this._apiBaseUrl, this._assetsUrl);

  /// Here we are storing the current list of pages
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: List.of(_pages),
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    _pages.clear();
    push(configuration);
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _removePage(_pages.last as MaterialPage);
      return Future.value(true);
    }
    return Future.value(false);
  }

  void push(PageConfiguration pageConfig) {
    final shouldPushPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;

    if (shouldPushPage) {
      var pageData = _getPageData(pageConfig);
      _addPageData(pageData!);
      notifyListeners();
    }
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    _pages.remove(route.settings);
    notifyListeners();

    return true;
  }

  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    push(newRoute);
  }

  PageData? _getPageData(PageConfiguration pageConfig) {
    switch (pageConfig.uiPage) {
      case Pages.Home:
        return PageData(
          HomePageWidget(
            apiClient: _apiClient,
            assetsUrl: _assetsUrl,
          ),
          HomePageConfig,
        );
      case Pages.SignUp:
        return PageData(SignUpWidget(_apiClient), SignUpConfig);
      case Pages.Login:
        return PageData(LoginWidget(_apiClient), LoginPageConfig);
      case Pages.Profile:
        return PageData(ProfileWidget(), ProfileConfig);
      case Pages.ForgotPassword:
        return PageData(ForgotPasswordWidget(_apiClient), ForgotPasswordConfig);
      case Pages.SetNewPassword:
        return PageData(SetNewPasswordWidget(_apiClient), SetNewPasswordConfig);
      case Pages.HALandingPage:
        return PageData(
          HALandingPageWidget(
            apiClient: _apiClient,
            apiBaseUrl: _apiBaseUrl,
            assetsUrl: _assetsUrl,
          ),
          HALandingPageConfig,
        );
      case Pages.HeartAssessmentQuestionnaire:
        return PageData(
          HeartAssessmentQuestionnaireWidget(apiClient: _apiClient),
          HeartAssessmentQuestionnaireConfig,
        );
      case Pages.HAResults:
        return PageData(
          HAResultsWidget(
            apiClient: _apiClient,
            assetsUrl: _assetsUrl,
          ),
          HAResultsConfig,
        );
      case Pages.AboutUs:
        return PageData(
          AboutUs(
            apiClient: _apiClient,
            assetsUrl: _assetsUrl,
          ),
          AboutUsConfig,
        );
      case Pages.CounsellingModulePrepUse:
        return PageData(
          CounsellingModulePageWidget(
            apiClient: _apiClient,
            assetsUrl: _assetsUrl,
            moduleName: 'prep_use',
          ),
          CounsellingModulePrepUseConfig,
        );
      case Pages.CounsellingModulePartnerComm:
        return PageData(
          CounsellingModulePageWidget(
            apiClient: _apiClient,
            assetsUrl: _assetsUrl,
            moduleName: 'partner_comm',
          ),
          CounsellingModulePrepUseConfig,
        );
      case Pages.CounsellingModuleIPV:
        return PageData(
          CounsellingModulePageWidget(
            apiClient: _apiClient,
            assetsUrl: _assetsUrl,
            moduleName: 'ipv',
          ),
          CounsellingModulePrepUseConfig,
        );
    }
  }

  void _addPageData(PageData pageData) {
    _pages.add(_createPage(pageData.widget, pageData.pageConfig));
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _removePage(MaterialPage page) {
    _pages.remove(page);
    notifyListeners();
  }
}

class PageData {
  Widget widget;
  PageConfiguration pageConfig;

  PageData(this.widget, this.pageConfig);
}
