import 'package:charisma/common/charisma_expandable_widget.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

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

    return Column(
      children: [
        Container(
          key: ValueKey('CounsellingModule'),
          padding: EdgeInsets.all(20),
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
              Html(
                data: moduleData!['introduction'],
                style: {'body': Style(color: infoTextColor)},
                key: ValueKey('CounsellingModuleIntro'),
              ),
              if (moduleData!['moduleImage'] != null)
                Image.network(
                  "$assetsUrl${moduleData!['moduleImage']['imageUrl']}",
                  fit: BoxFit.contain,
                  key: ValueKey('ModuleImage'),
                ),
              if (moduleData!['moduleVideo'] != null)
                Container(
                  key: ValueKey('ModuleVideo'),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: VideoPlayerWidget(
                      "$assetsUrl${moduleData!['moduleVideo']['videoUrl']}"),
                ),
              ListView.builder(
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
                        shrinkWrap: true,
                        itemCount: moduleSections[sectionIndex]
                                ['accordionContent']
                            .length,
                        itemBuilder:
                            (BuildContext context, int accordionIndex) =>
                                CharismaExpandableWidget(
                          title: moduleSections[sectionIndex]
                              ['accordionContent'][accordionIndex]['title'],
                          description: moduleSections[sectionIndex]
                                  ['accordionContent'][accordionIndex]
                              ['description'],
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
            ],
          ),
        ),
        if (moduleActions != null)
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
}
