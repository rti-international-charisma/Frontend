import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';

class CharismaCircularLoader extends StatelessWidget {
  const CharismaCircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Transform.scale(
        scale: 0.08,
        child: CircularProgressIndicator(
          strokeWidth: 40,
          valueColor: AlwaysStoppedAnimation(primaryColor),
        ),
      ),
    );
  }
}
