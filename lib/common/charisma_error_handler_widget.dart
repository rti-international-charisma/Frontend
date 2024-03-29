import 'package:charisma/account/user_state_model.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/constants.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharismaErrorHandlerWidget extends StatelessWidget {
  const CharismaErrorHandlerWidget({Key? key, this.error}) : super(key: key);

  final ErrorBody? error;

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    final userState = Provider.of<UserStateModel>(context);
    final sharedPrefHelper = SharedPreferenceHelper();

    int? errorCode = error?.code;

    if (errorCode == 401) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 80,
        child: Center(
          child: TextButton(
            onPressed: () {
              sharedPrefHelper.setUserData(null);
              userState.userLoggedOut();
              routerDelegate.replace(HomePageConfig);
            },
            child: Text(
              'Your session has expired.\nCLICK HERE to return to the home page.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 80,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              "Oops! Looks like something went wrong. Please try again later.",
              style: TextStyle(
                fontSize: 14,
                color: errorColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}
