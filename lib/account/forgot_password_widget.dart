
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_dropdown_widget.dart';
import 'package:charisma/common/charisma_textformfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ForgotPasswordWidget extends StatefulWidget {

  ApiClient apiClient;

  @override
  State<StatefulWidget> createState() => _ForgotPasswordWidgetState();

  ForgotPasswordWidget(this.apiClient);
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();
  final TextEditingController _securityQuestionAnswerCtrl = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  Future<List<Map<String, dynamic>>?>? getSecurityQuestionsFuture;

  @override
  Widget build(BuildContext context) {
    print('build-----');
    return FutureBuilder(
        future: widget.apiClient.get('/securityquestions/'),
        builder: (context, data) {
          print('DATA----- ${data.data}');
          if (data.hasData) {
            var allSecurityQuestions = data.data! as List<dynamic>;

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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 40),
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            SizedBox(height: 40),
                            CharismaTextFormField(
                              fieldKey: 'FPUsernameKey',
                              fieldName: 'Username',
                              controller: _usernameCtrl,
                            ),
                            SizedBox(height: 24),
                            CharismaDropdown(
                                key: ValueKey(''),
                                fieldName: 'Security Question',
                                items: toDropDownItems(allSecurityQuestions),
                                onChanged: (CharismaDropDownItem? item) {

                                }),
                            SizedBox(height: 24),
                            CharismaTextFormField(
                              fieldKey: 'FPSecQuestionsAnswer',
                              fieldName: 'Type your answer here',
                              controller: _securityQuestionAnswerCtrl,
                            ),
                            SizedBox(height: 24),
                            CharismaTextFormField(
                              fieldKey: 'FPPassword',
                              isObscurable: true,
                              fieldName: 'Create Password',
                              controller: _passwordCtrl,
                              focusNode: _passwordFocusNode,
                            ),
                            SizedBox(height: 24),
                            CharismaTextFormField(
                              fieldKey: 'FPConfirmPassword',
                              isObscurable: true,
                              fieldName: 'Confirm Password',
                              controller: _passwordConfirmCtrl,
                              focusNode: _confirmPasswordFocusNode,
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              height: 39,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {

                                  },
                                  child: Text('Create a new password'),
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
          } else if (data.hasError) {
            return Scaffold(
                body: Center(
                  child: Text("Something went wrong"),
                )
            );
          }
          return Transform.scale(scale: 0.1, child: CircularProgressIndicator());
        }
    );
  }

  toDropDownItems(List<dynamic> allSecurityQuestions) {
    return allSecurityQuestions.map((e) => CharismaDropDownItem(e['id'].toString(), e['question'])).toList();
  }
}