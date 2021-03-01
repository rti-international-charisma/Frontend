
import 'package:flutter/material.dart';

class NetworkImageBuilder {
  Image build(String imageUrl) {
    return Image.network(imageUrl);
  }
}