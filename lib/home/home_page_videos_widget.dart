import 'package:carousel_slider/carousel_slider.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:flutter/material.dart';

class HomePageVideos extends StatefulWidget {
  HomePageVideos({Key? key, this.data, this.apiBaseUrl}) : super(key: key);

  final data;
  final apiBaseUrl;

  @override
  _HomePageVideosState createState() => _HomePageVideosState();
}

class _HomePageVideosState extends State<HomePageVideos> {
  int expandedDescriptionIndex = -1;

  @override
  Widget build(BuildContext context) {
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
            height: 100,
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
          top: 200,
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            key: ValueKey('VideoCarousel'),
            itemCount: 4,
            options: CarouselOptions(
              height: 300,
              enableInfiniteScroll: false,
              viewportFraction: 0.85,
            ),
            itemBuilder: (context, index, realIndex) => Container(
              key: ValueKey('VideoModules'),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(4, 4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          widget.data['videos'][index]['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          key: ValueKey('VideoHeading${index + 1}'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new ConstrainedBox(
                        constraints: expandedDescriptionIndex == index
                            ? new BoxConstraints()
                            : new BoxConstraints(maxHeight: 25),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            widget.data['videos'][index]['description'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff929292),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            key: ValueKey('VideoSummary${index + 1}'),
                          ),
                        ),
                      ),
                      new TextButton(
                        onPressed: () => setState(() =>
                            expandedDescriptionIndex =
                                expandedDescriptionIndex == index ? -1 : index),
                        child: Text(
                            'Read ${expandedDescriptionIndex == index ? 'less' : 'more'}...'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (widget.data['videos'][index]['videoUrl'] == null)
                        Row(
                          children: [
                            Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width * 0.73,
                              child: Image.network(
                                  "${widget.apiBaseUrl}${widget.data['videos'][index]['videoImage']}"),
                            )
                          ],
                        )
                      else
                        Row(
                          children: [
                            Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width * 0.73,
                              child: VideoPlayerWidget(
                                "${widget.apiBaseUrl}${widget.data['videos'][index]['videoUrl']}",
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonTheme(
                              height: 322,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(widget.data['videos'][index]
                                      ['actionText']),
                                  style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8),
                                      ),
                                      primary: Color(0xff244E74),
                                      minimumSize: Size(0, 45))),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
