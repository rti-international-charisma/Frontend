import 'package:flutter/material.dart';

class HeroImageWidget extends StatelessWidget {
  const HeroImageWidget({Key? key, this.heroImageData}) : super(key: key);

  final heroImageData;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      new Image.network(
        "${heroImageData!['assets']['heroImage'][0]['url']}",
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
          child: Text(heroImageData['textContent']['heroImageText'],
              key: ValueKey('HeroImageText'),
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white)),
        ),
      )
    ]);
  }
}
