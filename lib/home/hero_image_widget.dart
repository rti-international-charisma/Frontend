import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class HeroImageWidget extends StatelessWidget {
  const HeroImageWidget({Key? key, this.data, this.assetsUrl})
      : super(key: key);

  final data;
  final assetsUrl;

  @override
  Widget build(BuildContext context) {
    print("$assetsUrl${data!['imageUrl']}");
    return Stack(children: <Widget>[
      new Image.network(
        "$assetsUrl${data!['imageUrl']}",
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
            data: data!['introduction'],
            key: ValueKey('HeroImageText'),
            style: {'body': Style(color: Colors.white)},
          ),
        ),
      )
    ]);
  }
}
