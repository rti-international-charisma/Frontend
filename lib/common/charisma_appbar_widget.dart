import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharismaAppBar extends StatelessWidget with PreferredSizeWidget {
  CharismaAppBar({Key? key, this.apiClient})
      : preferredSize = Size.fromHeight(80),
        super(key: key);

  final ApiClient? apiClient;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    return PreferredSize(
      child: AppBar(
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Color(0xff2DA4FA)),
        flexibleSpace: Padding(
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
        backgroundColor: Colors.white,
        actions: <Widget>[
          FutureBuilder<Map<String, dynamic>?>(
            future: apiClient?.getUserData(),
            builder: (context, data) {
              if (data.hasData && data.data!.isNotEmpty) {
                var userData = data.data!['user'];

                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(10, 10, 30, 10),
                  child: Text(
                    'Hi ${userData!['username']}!',
                    style: TextStyle(
                      color: Color(0xff2DA4FA),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    key: ValueKey('UserName'),
                  ),
                );
              }

              return Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: TextButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xff2DA4FA),
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
                      style: TextStyle(color: Color(0xff929292), fontSize: 14),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: TextButton(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xff2DA4FA),
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
