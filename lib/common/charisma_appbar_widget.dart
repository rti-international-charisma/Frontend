import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/common/charisma_menu_widget.dart';
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
        leading: CharismaMenuWidget(),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Color(0xff2DA4FA)),
        flexibleSpace: InkWell(
          onTap: () {
            routerDelegate.replace(HomePageConfig);
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
          Consumer<UserStateModel>(
            builder: (context, userState, child) {
              if (userState.isLoggedIn) {
                return FutureBuilder(
                    future: sharedPrefHelper.getUserData(),
                    builder: (context, data) {
                      return Row(
                        children: [
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
                                sharedPrefHelper.setUserData(null);
                                userState.userLoggedOut();
                                routerDelegate.replace(HomePageConfig);
                              },
                            ),
                          ),
                        ],
                      );
                    });
              } else {
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
                          routerDelegate.replace(SignUpConfig);
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
                          routerDelegate.replace(LoginPageConfig);
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
