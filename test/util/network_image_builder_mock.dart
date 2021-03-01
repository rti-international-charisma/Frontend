
import 'package:charisma/common/network_image_builder.dart';
import 'package:flutter/material.dart';

class MockNetworkImageBuilder implements NetworkImageBuilder {
  @override
  Image build(String imageUrl) {
    return Image.asset('assets/images/rti_logo.png');
  }
}