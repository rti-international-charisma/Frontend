
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerWidget2 extends StatefulWidget {
  String videoUrl;
  VideoPlayerWidget2(this.videoUrl);

  @override
  State<StatefulWidget> createState()  => _VideoPlayerWidget2State();

}

class _VideoPlayerWidget2State extends State<VideoPlayerWidget2> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: 'eg5ciqQzmK0',
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

    // _controller.onEnterFullscreen = () {
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight,
    //   ]);
    //   // Logger.log('Entered Fullscreen');
    // };
    // _controller.onExitFullscreen = () {
    //   // Logger.log('Exited Fullscreen');
    // };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
        controller: _controller,
        child: player);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

}