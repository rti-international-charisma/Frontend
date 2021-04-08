

const String HomePagePath = '/home';
const String LoginPath = '/login';
const String SignUpPath = '/singUp';
const String ProfilePath = '/profile';
const String ForgotPasswordPath = '/forgotpassword';

enum Pages {
  Home,
  Login,
  SignUp,
  Profile,
  ForgotPassword
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;

  const PageConfiguration({ this.key = "", this.path = HomePagePath, required this.uiPage });
}

const PageConfiguration HomePageConfig = PageConfiguration(key: 'Home', path: HomePagePath, uiPage: Pages.Home);
const PageConfiguration LoginPageConfig = PageConfiguration(key: 'Login', path: LoginPath, uiPage: Pages.Login);
const PageConfiguration SignUpConfig = PageConfiguration(key: 'SignUp', path: SignUpPath, uiPage: Pages.SignUp);
const PageConfiguration ProfileConfig = PageConfiguration(key: 'Profile', path: ProfilePath, uiPage: Pages.Profile);
const PageConfiguration ForgotPasswordConfig = PageConfiguration(key: 'ForgotPassword', path: ForgotPasswordPath, uiPage: Pages.ForgotPassword);