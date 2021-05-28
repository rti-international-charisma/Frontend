import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/constants.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharismaAppBar extends StatelessWidget with PreferredSizeWidget {
  CharismaAppBar({Key? key})
      : preferredSize = Size.fromHeight(80),
        super(key: ValueKey('CharismaAppBar'));

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    final sharedPrefHelper = SharedPreferenceHelper();

    return PreferredSize(
      child: AppBar(
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Color(0xff2DA4FA)),
        flexibleSpace: InkWell(
          onTap: () {
            routerDelegate.replaceAll(HomePageConfig);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 30, 0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/charisma_logo.png',
                key: ValueKey('CharismaLogo'),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Consumer2<UserStateModel, ApiClient>(
            builder: (context, userState, apiClient, child) {
              print('SESSION ACTIVE --- ${apiClient.isSessionActive}');
              if (userState.isLoggedIn) {
                return FutureBuilder(
                    future: sharedPrefHelper.getUserData(),
                    builder: (context, data) {
                      return Row(
                        children: [
                          if (apiClient.isSessionActive == false)
                            // Over here we are using the existing logout button to do the job,
                            // while just showing a prompt message.
                            // But we can instead render a new button here along with the prompt message text
                            // Pressing the button will logout the user.
                            // For that, make the current logout button render conditionally, don't render it when 401 happens.
                            Container(
                              width: 120,
                              child: Text(
                                'Your session has expired. Click Logout here to return to home page.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10, 10, 30, 10),
                            child: TextButton(
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Color(0xff2DA4FA),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              key: ValueKey('LogoutLink'),
                              onPressed: () {
                                // print('on  pressed');
                                sharedPrefHelper.setUserData(null);
                                userState.userLoggedOut();
                                routerDelegate.replaceAll(HomePageConfig);
                              },
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                // print('IS LOGGED OUT');
                return Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      child: TextButton(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: linkColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        key: ValueKey('SignUpLink'),
                        onPressed: () {
                          routerDelegate.push(SignUpConfig);
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '|',
                        style:
                            TextStyle(color: Color(0xff929292), fontSize: 14),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      child: TextButton(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: linkColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        key: ValueKey('LoginLink'),
                        onPressed: () {
                          routerDelegate.push(LoginPageConfig);
                        },
                      ),
                    )
                  ],
                );
              }
            },
          )
        ],
      ),
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        100,
      ),
    );
  }
}
