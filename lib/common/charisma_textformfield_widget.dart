
import 'package:flutter/material.dart';

import '../constants.dart';

class CharismaTextFormField extends StatefulWidget {
  String fieldName;

  String hintText;

  String infoText;

  var style;

  var keyboardType;

  var obscureText;

  var onChanged;

  var textFieldAlignment;

  final TextEditingController? controller;

  String? Function(String?)? validator;

  CharismaTextFormField({
    required Key key,
    required this.fieldName,
    this.hintText = '',
    this.infoText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.textFieldAlignment= MainAxisAlignment.start,
    this.controller,
    this.validator
  });


  @override
  State<StatefulWidget> createState() => _CharismaTextFieldState();

}

class _CharismaTextFieldState extends State<CharismaTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              widget.fieldName,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black
              )
          ),
          getInfoText(),
          Container(
            height: 36,
            child: TextFormField(
              obscureText: widget.obscureText,
              validator: widget.validator,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: textBorderColor
                    )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getInfoText() {
    if (widget.infoText.isEmpty) {
      return SizedBox(height: 0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4),
        Text(
            widget.infoText,
            key: ValueKey('InfoTextKey'),
            style: TextStyle(
                fontSize: 11,
                color: infoTextColor
            )
        ),
        SizedBox(height: 4)
      ],
    );
  }
}