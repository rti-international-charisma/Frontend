
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/charisma_dropdown_widget.dart';
import 'package:charisma/common/charisma_textformfield_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'account_details_validations.dart' show Validations;

class SignUpWidget extends StatefulWidget {
  ApiClient _apiClient;


  @override
  State<StatefulWidget> createState() => _SignupWidgetState();

  SignUpWidget(this._apiClient);
}

class _SignupWidgetState extends State<SignUpWidget> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();
  final TextEditingController _securityQuestionAnswerCtrl = TextEditingController();
  CharismaDropDownItem? selectedItem;

  List allSecurityQuestions = [];

  final _usernameFocusNode = FocusNode();
  bool isUsernameAvailable = false;

  @override
  void initState() {
    getAllSecurityQuestions();
    _usernameFocusNode.addListener(() {
      checkUsernameAvailability(_usernameCtrl.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 98,
          backgroundColor: Colors.white,
          title: Image.asset('assets/images/charisma_logo.png',
            fit: BoxFit.cover,
          ),
        ),
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Text('Register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                        SizedBox(height: 24),
                        CharismaTextFormField(
                            key: ValueKey('username'),
                            fieldName: 'Create Username',
                            infoText: 'Your username can be anything you want, but...\nDO make sure it’s something you will remember when you want to sign in.\nDO NOT use your Name, Phone number or Email ID',
                            controller: _usernameCtrl,
                            validator: (String? value) => value?.basicValidation,
                        focusNode: _usernameFocusNode,),
                        SizedBox(height: 24),
                        CharismaTextFormField(
                            key: ValueKey('password'),
                            obscureText: true,
                            fieldName: 'Create Password',
                            controller: _passwordCtrl,
                            validator: (String? value) => value?.passwordValidation
                        ),
                        SizedBox(height: 24),
                        CharismaTextFormField(
                            key: ValueKey('confirmpassword'),
                            fieldName: 'Confirm Password',
                            obscureText: true,
                            controller: _passwordConfirmCtrl,
                            validator: (String? value) => value?.passwordValidation
                        ),
                        SizedBox(height: 24),
                        CharismaDropdown(
                          key: ValueKey('secquestions'),
                          fieldName: 'Security Questions',
                          infoText: 'You will need to answer this question to retrieve your account if you forget your password or username',
                          items: toDropDownItem(allSecurityQuestions),
                          onChanged: (CharismaDropDownItem? item) {
                            selectedItem = item;
                            print('Selected ${item?.identifier} ${item
                                ?.displayValue}');
                          },
                        ),
                        SizedBox(height: 24),
                        CharismaTextFormField(
                            key: ValueKey('securityquestionsanswer'),
                            fieldName: 'Security Questions Answer',
                            controller: _securityQuestionAnswerCtrl,
                            validator: (String? value) => value?.basicValidation
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                            onPressed: () {
                              print('Register Clicked ${_passwordCtrl.text}');
                              if (_formKey.currentState!.validate()) {

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Snackk')));
                              } else {
                                print('Password ${_passwordCtrl.text}');
                              }
                            },
                            child: Text('Register')
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            TextButton(
                                onPressed: () {
                                  routerDelegate.push(LoginPageConfig);
                                },
                                child: Text('Login now')
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getAllSecurityQuestions() async {
    widget._apiClient.get('/securityquestions/')?.then((value) => {
      setState(() {
        allSecurityQuestions = value!.cast();
      })
    }).catchError((error) => {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Error while fetching questions.'),
            backgroundColor: Colors.red,
      ))
    });
  }

  List<CharismaDropDownItem> toDropDownItem(List<dynamic> allSecurityQuestions) {
    return allSecurityQuestions.map((e) => CharismaDropDownItem(e['id'].toString(), e['question'])).toList();
  }

  void checkUsernameAvailability(String text) {

  }
}