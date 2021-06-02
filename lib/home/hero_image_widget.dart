import 'package:charisma/common/network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

class HeroImageWidget extends StatelessWidget {
  const HeroImageWidget({
    Key? key,
    @required this.data,
    this.userGreeting,
    this.assetsUrl,
    this.isTestComplete,
  }) : super(key: key);

  final Map<String, dynamic>? data;
  final String? userGreeting;
  final String? assetsUrl;
  final bool? isTestComplete;

  String getCaption(Map<String, dynamic>? data) {
    switch (isTestComplete) {
      case true:
        return (userGreeting ?? '') + data!['heroImageCaptionTestComplete'];
      case false:
        return (userGreeting ?? '') + data!['heroImageCaptionTestIncomplete'];
      default:
        return data!['introduction'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Provider.of<NetworkImageBuilder>(context).build("$assetsUrl${data!['imageUrl']}"),
      Positioned(
        bottom: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(20),
          child: Html(
            data: getCaption(data),
            key: ValueKey('HeroImageText'),
            style: {'body': Style(color: Colors.white)},
          ),
        ),
      )
    ]);
  }
}
