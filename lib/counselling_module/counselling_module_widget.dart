import 'package:carousel_slider/carousel_slider.dart';
import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:charisma/common/youtube_player_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logger.dart';

class CounsellingModuleWidget extends StatelessWidget {
  const CounsellingModuleWidget({
    Key? key,
    @required this.moduleData,
    @required this.assetsUrl,
  }) : super(key: key);

  final Map<String, dynamic>? moduleData;
  final String? assetsUrl;

  @override
  Widget build(BuildContext context) {
    var moduleSections = moduleData!['counsellingModuleSections'];
    var moduleActions = moduleData!['counsellingModuleActionPoints'];
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Container(
          key: ValueKey('CounsellingModule'),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  moduleData!["title"],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  key: ValueKey('CounsellingModuleTitle'),
                ),
              ),
              if (moduleData!['introduction'] != null)
                Html(
                  data: moduleData!['introduction'],
                  style: {'body': Style(color: infoTextColor)},
                  key: ValueKey('CounsellingModuleIntro'),
                ),
              if (moduleData!['moduleImage'] != null)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Image.network(
                    "$assetsUrl${moduleData!['moduleImage']['imageUrl']}",
                    fit: BoxFit.contain,
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
                    key: ValueKey('ModuleImage'),
                  ),
                ),
              SizedBox(height: 8),
              if (moduleData!['videoSection'] != null)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: (moduleData!['videoSection']['videos'] as List).map(
                            (video) =>
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    width: getItemWidth(context),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        key: ValueKey('ModuleVideo'),
                                        child: YoutubePlayerWidget(
                                            "${video['youtubeVideoUrl']}"
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                    ).toList(),
                  ),
                ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: moduleSections.length,
                itemBuilder: (BuildContext context, int sectionIndex) => Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        moduleSections[sectionIndex]['title'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        key: ValueKey('SectionTitle$sectionIndex'),
                      ),
                    ),
                    Html(
                      data: moduleSections[sectionIndex]['introduction'],
                      key: ValueKey('SectionIntro$sectionIndex'),
                    ),
                    if (moduleSections[sectionIndex]['accordionContent'] !=
                        null)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: moduleSections[sectionIndex]
                                ['accordionContent']
                            .length,
                        itemBuilder:
                            (BuildContext context, int accordionIndex) =>
                                CharismaExpandableWidget(
                          data: moduleSections[sectionIndex]['accordionContent']
                              [accordionIndex],
                          assetsUrl: assetsUrl,
                          key: ValueKey(
                              'SectionAccordion$sectionIndex-$accordionIndex'),
                        ),
                      ),
                    if (moduleSections[sectionIndex]['summary'] != null)
                      Html(
                        data: moduleSections[sectionIndex]['summary'],
                        key: ValueKey('SectionSummary$sectionIndex'),
                      ),
                  ],
                ),
              ),
              if (!moduleData!["title"].toString().contains("healthy relationship"))
                Html( data:"<h3>Healthy Relationships</h3>"),
              if (!moduleData!["title"].toString().contains("healthy relationship"))
                Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 10),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text: 'Curious about other aspects of “Healthy Relationships” click ',
                        style: new TextStyle(color: Colors.black),
                      ),
                      new TextSpan(
                        text: 'here.',
                        style: new TextStyle(color: Colors.blue),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () { launch('#/module/healthy_relationship', webOnlyWindowName:'_self');
                          },
                      ),
                    ],
                  ),
                ),
              )
            ])
        ),
        if (moduleActions != null && moduleActions.isNotEmpty)
          Container(
            key: ValueKey('ActionPoints'),
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: ternaryColor,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Action points for you!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: moduleActions.length,
                  itemBuilder: (BuildContext context, int index) => Card(
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        moduleActions[index]['title'],
                        style: TextStyle(
                          color: ternaryColor,
                        ),
                        key: ValueKey('ActionPoint$index'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  double getItemWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width > 800) {
      // For Desktop browser
      return MediaQuery.of(context).size.width * 0.25;
    } else {
      // For phone browser
      return MediaQuery.of(context).size.width * 0.75;
    }
  }
}
