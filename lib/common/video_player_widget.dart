import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
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
    _videoController = VideoPlayerController.network(widget.videoUrl);

    _chewieController = ChewieController(
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      isLive: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.transparent,
        handleColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        bufferedColor: Colors.transparent,
      ),
      placeholder: Container(
        color: Colors.black87,
      ),
      autoInitialize: true,
      fullScreenByDefault: false,
    );

    _chewieController.deviceOrientationsAfterFullScreen.clear();
    _chewieController.deviceOrientationsAfterFullScreen
        .add(DeviceOrientation.portraitUp);

    _videoController.addListener(() {
      var duration = _videoController.value.duration;
      var position = _videoController.value.position;
      if ((_chewieController != null && _chewieController.isFullScreen) &&
          (position >= (duration - Duration(seconds: 1)))) {
        _chewieController.exitFullScreen();
        videoFinished();
      }

      if (position == duration) {
        videoFinished();
      }
    });
  }

  void videoFinished() {
    setState(() {
      isVideoFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
