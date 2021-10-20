
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_textformfield_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logger.dart';
import 'account_details_validations.dart' show Validations;
import '../constants.dart';

class SetNewPasswordWidget extends StatefulWidget {
  ApiClient apiClient;

  SetNewPasswordWidget(this.apiClient);

  @override
  State<StatefulWidget> createState() => _SetNewPasswordWidget();

}

class _SetNewPasswordWidget extends State<SetNewPasswordWidget> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();


  @override
  void initState() {
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus &&
          _passController.text.passwordValidation != null) {
        showPasswordCriteriaDialog();
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus &&
          _confirmPassController.text.isNotEmpty &&
          !doPasswordsMatch()) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    return  Scaffold(
      appBar:  AppBar(
        toolbarHeight: 98,
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/charisma_logo.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            body: Container(
              key: ValueKey('FPMainContainerKey'),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Setup New Password',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 40),
                    CharismaTextFormField(
                      fieldKey: 'SPPasswordKey',
                      isObscurable: true,
                      fieldName: 'New Password',
                      controller: _passController,
                      focusNode: _passwordFocusNode,
                    ),
                    SizedBox(height: 24),
                    CharismaTextFormField(
                      fieldKey: 'SPConfirmPasswordKey',
                      isObscurable: true,
                      fieldName: 'Confirm New Password',
                      controller: _confirmPassController,
                      focusNode: _confirmPasswordFocusNode,
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      height: 39,
                      width: double.infinity,
                      child: ElevatedButton(
                          key: ValueKey('SPSetPassButton'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() && validatePasswords()) {
                              Logger.log('Ready to update password');
                              String? token =
                              await SharedPreferenceHelper().getPasswordToken();
                              widget.apiClient.postWithHeaders('/reset-password',
                                  {
                                    "newPassword":_passController.text
                                  },
                                  {
                                    "Authorization" : "Bearer $token"
                                  }
                              )?.then((value) {
                                Logger.log('Update Password Success :$value');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('New password set successfully.'),
                                  backgroundColor: Colors.lightGreen,
                                ));
                                routerDelegate.replace(LoginPageConfig);
                              }).catchError((error) {
                                Logger.log('Update Password Error');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Something went wrong'),
                                  backgroundColor: Colors.red,
                                ));
                              });
                            }
                          },
                          child: Text('Set password'),
                          style: ElevatedButton.styleFrom(
                            primary: ternaryColor,
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool doPasswordsMatch() => (_passController.text == _confirmPassController.text);

  bool validatePasswords() {
    if (_passController.text.passwordValidation != null) {
      showPasswordCriteriaDialog();
      return false;
    } else if (!doPasswordsMatch()) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    return true;
  }

  Future<void> showPasswordCriteriaDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('! make sure password has the below'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('1. Should be more than 8 characters'),
                  Text('2. At least 1 capital letter'),
                  Text('3. At least 1 lowercase letter'),
                  Text('4. At least 1 digit'),
                  Text('5. At least 1 special symbol (e.g. @#\$%), For example:Ab1@5')
                ],
              ),
            ),
          );
        });
  }
}