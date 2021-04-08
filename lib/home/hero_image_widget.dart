import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class HeroImageWidget extends StatelessWidget {
  const HeroImageWidget({Key? key, this.data, this.apiBaseUrl})
      : super(key: key);

  final data;
  final apiBaseUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      new Image.network(
        "$apiBaseUrl/assets/${data!['hero_image'][0]['image_file']}",
        fit: BoxFit.cover,
        width: double.infinity,
        alignment: Alignment.center,
        key: ValueKey('HeroImage'),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(20),
          child: Html(
            data: data!['hero_image'][0]['introduction'],
            key: ValueKey('HeroImageText'),
            style: {'body': Style(color: Colors.white)},
          ),
        ),
      )
    ]);
  }
}
