import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_textformfield_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'account_details_validations.dart' show Validations;
import '../constants.dart';

class LoginWidget extends StatefulWidget {
  final ApiClient _apiClient;

  LoginWidget(this._apiClient);

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 98,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/charisma_logo.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                     if (isLoading) Positioned.fill(child: Align(alignment: Alignment.center,child: CircularProgressIndicator())),
                    Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 40),
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 24),
                              CharismaTextFormField(
                                fieldKey: 'LoginUNameKey',
                                fieldName: 'Username',
                                controller: _usernameCtrl,
                                validator: (value) {
                                  return value?.basicValidation;
                                },
                              ),
                              SizedBox(height: 24),
                              CharismaTextFormField(
                                fieldKey: 'LoginPWordKey',
                                fieldName: 'Passoword',
                                controller: _passwordCtrl,
                                isObscurable: true,
                                validator: (value) {
                                  return value?.basicValidation;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    key: Key('LoginForgotPWordKey'),
                                    onPressed: () {
                                      print('Forgot Password tapped');
                                      routerDelegate.push(ForgotPasswordConfig);
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                    )),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                  height: 39,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    key: Key('LoginLoginBtnKey'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        widget._apiClient.post<Map<String, dynamic>?>(
                                            '/login', {
                                          "username": _usernameCtrl.text,
                                          "password": _passwordCtrl.text
                                        })?.then((data) async {
                                          SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                          prefs.setString(
                                              'userData', convert.jsonEncode(data));
                                          setState(() {
                                            isLoading = false;
                                          });
                                          routerDelegate.push(HomePageConfig);
                                        }).catchError((error) async {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                (((error as ErrorBody).body))['body'],
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return null;
                                        });
                                      }
                                    },
                                    child: Text('Login'),
                                    style: ElevatedButton.styleFrom(
                                      primary: ternaryColor,
                                    ),
                                  )),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Don' 't have an account?'),
                                  TextButton(
                                      key: Key('LoginRegisterBtnKey'),
                                      onPressed: () {
                                        print(' Register now tapped');
                                        routerDelegate.push(SignUpConfig);
                                      },
                                      child: Text('Register now'))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
