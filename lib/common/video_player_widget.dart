import 'package:chewie/chewie.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget(this.videoUrl);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoController;
  bool isFullscreen = false;
  bool isVideoFinished = false;

  @override
  void initState() {
    super.initState();
  }

  void videoFinished() {
    setState(() {
      isVideoFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _videoController = VideoPlayerController.network(widget.videoUrl);

    _chewieController = ChewieController(
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      videoPlayerController: _videoController,
      aspectRatio: 16 / 9,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.transparent,
        handleColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        bufferedColor: Colors.transparent,
      ),
      placeholder: Container(
        color: Colors.black87,
      ),
      errorBuilder: (BuildContext context, String errorMessage) => Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(10),
        child: Text(
          'Oops, looks like something went wrong, please reload',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
      routePageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        _chewieControllerProvider,
      ) =>
          Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: _chewieControllerProvider,
      ),
    );

    _chewieController.deviceOrientationsAfterFullScreen.clear();
    _chewieController.deviceOrientationsAfterFullScreen
        .add(DeviceOrientation.portraitUp);

    _videoController.addListener(() {
      var duration = _videoController.value.duration;
      var position = _videoController.value.position;
      if (_chewieController.isFullScreen &&
          (position >= (duration - Duration(seconds: 1)))) {
        _chewieController.exitFullScreen();
        videoFinished();
      }

      if (position == duration) {
        videoFinished();
      }
    });

    return Container(
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
