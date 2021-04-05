
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
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isUsernameAvailable = false;

  @override
  void initState() {
    getAllSecurityQuestions();
    _usernameFocusNode.addListener(() {
      if(!_usernameFocusNode.hasFocus) {
        validateUsername(_usernameCtrl.text);
      }
    });

    _passwordFocusNode.addListener(() {
      if(!_passwordFocusNode.hasFocus && _passwordCtrl.text.passwordValidation != null) {
        showPasswordCriteriaDialog();
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if(!_confirmPasswordFocusNode.hasFocus && _passwordConfirmCtrl.text.isNotEmpty && !doPasswordsMatch()) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Passwords do not match'),
              backgroundColor: Colors.red,
            )
        );
      }
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
                          errorText: showUsernameErrorText(_usernameCtrl.text, _isUsernameAvailable),
                          validator: (value) {
                            if (value?.basicValidation != null ) {
                              return value?.basicValidation;
                            } else if (_isUsernameAvailable) {
                              return null;
                            } else {
                              return 'Username entered already exists';
                            }
                          },
                          focusNode: _usernameFocusNode,),
                        SizedBox(height: 24),
                        CharismaTextFormField(
                          key: ValueKey('password'),
                          obscureText: true,
                          fieldName: 'Create Password',
                          controller: _passwordCtrl,
                          focusNode: _passwordFocusNode,
                        ),
                        SizedBox(height: 24),
                        CharismaTextFormField(
                          key: ValueKey('confirmpassword'),
                          fieldName: 'Confirm Password',
                          obscureText: true,
                          controller: _passwordConfirmCtrl,
                          focusNode: _confirmPasswordFocusNode,
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
                              print('Register Clicked');
                              validateUsername(_usernameCtrl.text).then((usernameAvailable) => {
                                if (_formKey.currentState!.validate() && usernameAvailable && validatePasswords()) {
                                  print('All things good'),
                                  widget._apiClient.post<Map<String, dynamic>>('/signup', {
                                    "username": _usernameCtrl.text.toLowerCase(),
                                    "password": _passwordCtrl.text,
                                    "secQuestionId": selectedItem?.identifier,
                                    "secQuestionAnswer" : _securityQuestionAnswerCtrl.text.toLowerCase()
                                  }).then((value) => {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have been successfully registered'))),
                                    routerDelegate.push(LoginPageConfig)
                                  }).catchError((error) => {
                                    print("Signup Error : $error"),
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('We were unable to register you, please try again later')))
                                  })
                                }
                              });
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

  bool doPasswordsMatch() => (_passwordCtrl.text == _passwordConfirmCtrl.text);

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

  Future<bool> validateUsername(String uname) async {
    await widget._apiClient.get('/user/availability/$uname')?.
    then((value) => {
      setState(() {
        _isUsernameAvailable = value?['available'];
      })
    }).
    catchError((error) => {
      print('Error ${(error as ErrorBody).body}'),
      _isUsernameAvailable = false
    });
    return _isUsernameAvailable;
  }

  bool validatePasswords() {
    if (_passwordCtrl.text.passwordValidation != null) {
       showPasswordCriteriaDialog();
       return false;
    } else if (!doPasswordsMatch()) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ));
      return false;
    }
    return true;
  }


  String? showUsernameErrorText(String text, bool isUsernameAvailable) {
    if (text.isEmpty) return null;

    if (!_isUsernameAvailable) {
      return 'Username entered already exists';
    }
  }

  Future<void> showPasswordCriteriaDialog() async{
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
      }
    );
  }
}