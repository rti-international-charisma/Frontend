
import 'package:flutter/material.dart';

import '../constants.dart';

class CharismaDropdown extends StatefulWidget {

  String fieldName;

  String hintText;

  String infoText;

  List<CharismaDropDownItem> items;

  ValueChanged<CharismaDropDownItem?> onChanged;

  CharismaDropdown({
    required Key key,
    required this.fieldName,
    this.hintText = '',
    this.infoText = '',
    required this.items,
    required this.onChanged
  });


  @override
  State<StatefulWidget> createState() => _CharismaDropdownState();

}

class _CharismaDropdownState extends State<CharismaDropdown> {

  CharismaDropDownItem? selectedItem;

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
            child: DropdownButton<CharismaDropDownItem>(
                key: ValueKey('CharismaDDButtonKey'),
                value: selectedItem,
                isExpanded: true,
                items: widget.items.map<DropdownMenuItem<CharismaDropDownItem>>((CharismaDropDownItem value) {
                  return DropdownMenuItem<CharismaDropDownItem>(
                    key: ValueKey(value.identifier+'_'+value.displayValue),
                    value: value,
                    child: Text(value.displayValue, style:TextStyle(color:Colors.black)),
                  );
                }).toList(),
                onChanged: (CharismaDropDownItem? item) {
                  setState(() {
                    selectedItem = item;
                  });
                  widget.onChanged(item);
                }
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
            key: ValueKey('DDInfoTextKey'),
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

class CharismaDropDownItem {
  String identifier;
  String displayValue;

  CharismaDropDownItem(this.identifier, this.displayValue);
}