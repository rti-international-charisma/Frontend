
import 'package:charisma/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerWidget extends StatefulWidget {
  String videoUrl;
  YoutubePlayerWidget(this.videoUrl);

  @override
  State<StatefulWidget> createState()  => _YoutubePlayerWidgetState();

}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
    var videoId = getVideoId(widget.videoUrl);
    _controller = YoutubePlayerController(
        initialVideoId: videoId,
        params: YoutubePlayerParams(
            autoPlay: false,
            showControls: true,
            showFullscreenButton: false,
            desktopMode: true,
            privacyEnhanced: true,
            useHybridComposition: true,
            playsInline: false,
            enableJavaScript: false,
            enableCaption: false
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
    );
    return YoutubePlayerControllerProvider(
        controller: _controller,
        child: player);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  getVideoId(String videoUrl) {
    var uri = Uri.parse(videoUrl);
    var videoId = uri.queryParameters['v'];
    return videoId;
  }
}