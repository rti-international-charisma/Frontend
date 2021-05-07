const String HomePagePath = '/home';
const String LoginPath = '/login';
const String SignUpPath = '/singUp';
const String ProfilePath = '/profile';
const String ForgotPasswordPath = '/forgotpassword';
const String SetNewPasswordPath = '/setnewpassword';
const String HALandingPagePath = '/assessment/intro';
const String HeartAssessmentQuestionnairePath =
    '/heart_assessment_questionnaire';
const String HAResultsPath = '/assessment/results';
const String AboutUsPath = '/aboutus';

enum Pages {
  Home,
  Login,
  SignUp,
  Profile,
  ForgotPassword,
  SetNewPassword,
  HALandingPage,
  HeartAssessmentQuestionnaire,
  HAResults,
  AboutUs,
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;

  const PageConfiguration(
      {this.key = "", this.path = HomePagePath, required this.uiPage});
}

const PageConfiguration HomePageConfig = PageConfiguration(
  key: 'Home',
  path: HomePagePath,
  uiPage: Pages.Home,
);
const PageConfiguration LoginPageConfig = PageConfiguration(
  key: 'Login',
  path: LoginPath,
  uiPage: Pages.Login,
);
const PageConfiguration SignUpConfig = PageConfiguration(
  key: 'SignUp',
  path: SignUpPath,
  uiPage: Pages.SignUp,
);
const PageConfiguration ProfileConfig = PageConfiguration(
  key: 'Profile',
  path: ProfilePath,
  uiPage: Pages.Profile,
);
const PageConfiguration ForgotPasswordConfig = PageConfiguration(
  key: 'ForgotPassword',
  path: ForgotPasswordPath,
  uiPage: Pages.ForgotPassword,
);
const PageConfiguration SetNewPasswordConfig = PageConfiguration(
  key: 'SetNewPassword',
  path: SetNewPasswordPath,
  uiPage: Pages.SetNewPassword,
);
const PageConfiguration HALandingPageConfig = PageConfiguration(
  key: 'HALandingPage',
  path: HALandingPagePath,
  uiPage: Pages.HALandingPage,
);
const PageConfiguration HeartAssessmentQuestionnaireConfig = PageConfiguration(
  key: 'HeartAssessmentQuestionnaire',
  path: HeartAssessmentQuestionnairePath,
  uiPage: Pages.HeartAssessmentQuestionnaire,
);
const PageConfiguration HAResultsConfig = PageConfiguration(
  key: 'HAResults',
  path: HAResultsPath,
  uiPage: Pages.HAResults,
);
const PageConfiguration AboutUsConfig = PageConfiguration(
  key: 'AboutUs',
  path: AboutUsPath,
  uiPage: Pages.AboutUs,
);
