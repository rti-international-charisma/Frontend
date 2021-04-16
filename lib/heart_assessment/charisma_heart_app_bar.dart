
import 'package:flutter/material.dart';

class CharismaHEARTAppBar extends PreferredSize {
  var height;

  var child;

  CharismaHEARTAppBar({
    required this.child,
    this.height = kToolbarHeight
  }) : super(child: child, preferredSize: Size.fromHeight(height));

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: child
    );
  }
}