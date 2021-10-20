
import 'package:charisma/common/youtube_player_widget.dart';
import 'package:charisma/navigation/charisma_parser.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class HomePageVideos extends StatefulWidget {
  HomePageVideos({
    Key? key,
    this.data,
    this.assetsUrl,
    required this.isLoggedIn,
  }) : super(key: key);

  final data;
  final assetsUrl;
  final isLoggedIn;

  @override
  _HomePageVideosState createState() => _HomePageVideosState();
}

class _HomePageVideosState extends State<HomePageVideos> {
  int expandedDescriptionIndex = -1;
  CharismaParser _parser = CharismaParser();
  Map<String, int> expanded = {};

  @override
  Widget build(BuildContext context) {
    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);
    List videos = widget.isLoggedIn
        ? widget.data['videos']
        : (widget.data['videos'] as List)
        .where((video) => !video['isPrivate'])
        .toList();

    if (widget.isLoggedIn) {
      List privateVideos =
      (videos as List).where((video) => video['isPrivate']).toList();

      List publicVideos = videos.where((video) => !video['isPrivate']).toList();

      videos = privateVideos + publicVideos;
      videos.map((e) => expanded[e['title']] = 0);
    }
    return Stack(
      key: ValueKey("VideoSection"),
      children: <Widget>[
        Container(
          height: 540,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff1261AA), Color(0xff2DA4FA), Color(0xff2DA4FA)],
                stops: [0.2665, 0.9213, 0.9213],
              )),
        ),
        Positioned(
          top: 50,
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Text(widget.data['introduction'],
                key: ValueKey('VideoSectionHeadline'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
          ),
        ),
        Positioned(
          top: 130,
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Text(widget.data['summary'],
                key: ValueKey('VideoSectionSubHeadline'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        Positioned(
          top: 180,
          width: MediaQuery.of(context).size.width,
          child:  Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                key: ValueKey('VideoCarousel'),
                children:videos.map((video) =>
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Container(
                          key: ValueKey('VideoModules'),
                          height: 345,
                          width: getItemWidth(context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child:  SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(left:16, right:16),
                              child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      height: 35,
                                      child: Text(
                                        video!['title'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        key: ValueKey('VideoHeading ${video['title']}'),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: expanded[video['title']]== 1
                                          ? new BoxConstraints()
                                          : new BoxConstraints(maxHeight: 25),
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          video['description'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xff929292),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          key: ValueKey('VideoSummary ${video['title']}'),
                                        ),
                                      ),
                                    ),
                                    new TextButton(
                                      onPressed: () => setState(() =>
                                      expanded[video['title']] =
                                      expanded[video['title']] == 1 ? 0 : 1),
                                      child: Text(
                                          'Read ${expandedDescriptionIndex == 1 ? 'less' : 'more'}...'),
                                    ),
                                    if (video['youtubeVideoUrl'] == null)
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                            "${widget.assetsUrl}${video['videoImage']}"),
                                      )
                                     else
                                      Container(
                                          child: YoutubePlayerWidget(video['youtubeVideoUrl'])
                                      ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        height: 39,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          key: Key('RegisterButtonKey'),
                                          onPressed: () {
                                            Future<PageConfiguration> pageConfigFuture =
                                            _parser.parseRouteInformation(
                                              RouteInformation(
                                                location: video['actionLink'],
                                              ),
                                            );

                                            pageConfigFuture.then((pageConfig) {
                                              return routerDelegate.replace(pageConfig);
                                            });

                                          },
                                          child: Text(video['actionText']),
                                          style: ElevatedButton.styleFrom(
                                            primary: ternaryColor,
                                          ),
                                        )
                                    )
                                  ]
                              ),
                            ),
                          )
                      ),
                    )
                ).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T>? items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items!) {
      yield f(index, item);
      index = index + 1;
    }
  }

}

///
/// Workaround for the width calculation.
/// This calculates the carousel item width based on the screen width
/// The VideoPlayer maintains the aspect ratio and bigger width increases the
/// VideoPlayer's height.
/// This basically calculates the width for desktop browser and phone
///
double getItemWidth(BuildContext context) {
  if (MediaQuery.of(context).size.width > 800) {
    // For Desktop browser
    return MediaQuery.of(context).size.width * 0.25;
  } else {
    // For phone browser
    return MediaQuery.of(context).size.width * 0.75;
  }
}