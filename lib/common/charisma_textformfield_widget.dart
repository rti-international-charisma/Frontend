
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

  var errorText;

  FocusNode? focusNode;

  var isObscurable;

  String? fieldKey;

  CharismaTextFormField({
    required this.fieldKey,
    required this.fieldName,
    this.hintText = '',
    this.infoText = '',
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.textFieldAlignment= MainAxisAlignment.start,
    this.controller,
    this.validator,
    this.focusNode,
    this.errorText,
    this.isObscurable = false
  });


  @override
  State<StatefulWidget> createState() => _CharismaTextFieldState();

}

class _CharismaTextFieldState extends State<CharismaTextFormField> {
  bool _obscureText = false;

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _obscureText = widget.isObscurable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(widget.fieldKey!),
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
              controller: widget.controller,
              focusNode: widget.focusNode,
              obscureText:_obscureText,
              validator: widget.validator,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: textBorderColor
                      )
                  ),
                  errorText: widget.errorText,
                  suffixIcon: getSuffixIcon()
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

  getSuffixIcon() {
    if(widget.isObscurable) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: _toggle,
        color: infoTextColor,
      );
    }
  }
}