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
      case CounsellingModuleHealthyRelationshipPath:
        return CounsellingModuleHealthyRelationshipConfig;
      case CounsellingModulePartnerCommPath:
        return CounsellingModulePartnerCommConfig;
      case CounsellingModulePrepUsePath:
        return CounsellingModulePrepUseConfig;
      case CounsellingModuleIPVPath:
        return CounsellingModuleIPVConfig;
      case AboutUsPath:
        return AboutUsConfig;
      case ReferralsPath:
        return ReferrlasConfig;
      case HIVPreventionPrepPath:
        return HIVPreventionPrepConfig;
      case MalePartnerInfoPath:
        return MalePartnerInfoConfig;
      default:
        return HomePageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Home:
        return const RouteInformation(location: HomePagePath);
      case Pages.Login:
        return const RouteInformation(location: LoginPath);
      case Pages.SignUp:
        return const RouteInformation(location: SignUpPath);
      case Pages.Profile:
        return const RouteInformation(location: ProfilePath);
      case Pages.ForgotPassword:
        return const RouteInformation(location: ForgotPasswordPath);
      case Pages.HALandingPage:
        return const RouteInformation(location: HALandingPagePath);
      case Pages.HeartAssessmentQuestionnaire:
        return const RouteInformation(location: HeartAssessmentQuestionnairePath);
      case Pages.HAResults:
        return const RouteInformation(location: HAResultsPath);
      case Pages.CounsellingModuleHealthyRelationship:
        return const RouteInformation(location: CounsellingModuleHealthyRelationshipPath);
      case Pages.CounsellingModulePartnerComm:
        return const RouteInformation(location: CounsellingModulePartnerCommPath);
      case Pages.CounsellingModulePrepUse:
        return const RouteInformation(location: CounsellingModulePrepUsePath);
      case Pages.CounsellingModuleIPV:
        return const RouteInformation(location: CounsellingModuleIPVPath);
      case Pages.AboutUs:
        return const RouteInformation(location: AboutUsPath);
      case Pages.Referrals:
        return const RouteInformation(location: ReferralsPath);
      case Pages.HIVPreventionPrep:
        return const RouteInformation(location: HIVPreventionPrepPath);
      case Pages.MalePartnerInfo:
        return const RouteInformation(location: MalePartnerInfoPath);
      default:
        return const RouteInformation(location: HomePagePath);
    }
  }
}
