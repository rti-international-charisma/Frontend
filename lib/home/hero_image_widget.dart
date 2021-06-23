import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

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
    return Container(
      color: infoTextColor,
      child: SizedBox(
        height: 500,
        child: Stack(
          children: <Widget>[
            new Image.network(
              "$assetsUrl${data!['imageUrl']}",
              fit: BoxFit.cover,
              width: double.infinity,
              alignment: Alignment.center,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;

                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              key: ValueKey('HeroImage'),
            ),
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
          ],
        ),
      ),
    );
  }
}
