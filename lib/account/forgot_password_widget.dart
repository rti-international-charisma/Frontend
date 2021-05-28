
import 'package:charisma/account/account_details_validations.dart';
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/common/charisma_dropdown_widget.dart';
import 'package:charisma/common/charisma_textformfield_widget.dart';
import 'package:charisma/common/shared_preference_helper.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _securityQuestionAnswerCtrl = TextEditingController();

  Future<List<Map<String, dynamic>>?>? getSecurityQuestionsFuture;
  CharismaDropDownItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    return FutureBuilder(
        future: widget.apiClient.get('/securityquestions/'),
        builder: (context, data) {
          if (data.hasData) {
            var allSecurityQuestions = data.data! as List<dynamic>;
            return  Scaffold(
              appBar: CharismaAppBar(),
              body: Form(
                key: _formKey,
                child: SafeArea(
                  child: Scaffold(
                    key: _scaffoldKey,
                    body: SingleChildScrollView(
                      child: Container(
                        key: ValueKey('FPMainContainerKey'),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                validator: (String? value) => value?.basicValidation,
                              ),
                              SizedBox(height: 24),
                              CharismaDropdown(
                                  key: ValueKey('FPSecQuestionDP'),
                                  fieldName: 'Security Question',
                                  items: toDropDownItems(allSecurityQuestions),
                                  onChanged: (CharismaDropDownItem? item) {
                                    selectedItem = item;
                                  }),
                              SizedBox(height: 24),
                              CharismaTextFormField(
                                fieldKey: 'FPSecQuestionsAnswer',
                                fieldName: 'Type your answer here',
                                controller: _securityQuestionAnswerCtrl,
                                validator: (String? value) => value?.basicValidation,
                              ),
                              SizedBox(height: 24),
                              SizedBox(
                                height: 39,
                                width: double.infinity,
                                child: ElevatedButton(
                                    key: ValueKey('FPNewPassButton'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate() && selectedItem != null) {
                                        print('Verifying SecQ and Ans');
                                        widget.apiClient.post('/verify-securityquestion',
                                            {
                                              "username":_usernameCtrl.text.toLowerCase(),
                                              "secQuestionId":selectedItem!.identifier,
                                              "secQuestionAnswer":_securityQuestionAnswerCtrl.text
                                            }
                                        )?.then((value) {
                                          SharedPreferenceHelper().setUserData(value);
                                          routerDelegate.push(SetNewPasswordConfig);
                                        }).catchError((error) {
                                          print('VerifyQuestion Error');
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('${(error as ErrorBody).body['body']}'),
                                            backgroundColor: Colors.red,
                                          ));
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Please select all the fields'),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                    },
                                    child: Text('Create a new password'),
                                    style: ElevatedButton.styleFrom(
                                      primary: ternaryColor,
                                    )
                                ),
                              ),
                              SizedBox(height: 35),
                              Text(
                                'Can’t remember the answer to your security question?',
                                style: TextStyle (
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15
                                ),
                              ),
                              SizedBox(height: 8),
                              TextButton(
                                  key: Key('FPRegisterButtonKey'),
                                  onPressed: () {
                                    routerDelegate.push(SignUpConfig);
                                  },
                                  child: Text('Register for a new account')
                              )
                            ],
                          ),
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