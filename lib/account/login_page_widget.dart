
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 98,
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/charisma_logo.png',
          fit: BoxFit.cover,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Text('Login'),
        ),
      ),
    );
  }

}