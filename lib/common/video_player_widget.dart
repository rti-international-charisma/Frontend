import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isFullscreen;

  VideoPlayerWidget(this.videoUrl, {this.isFullscreen = false});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  static Duration videoPosition = Duration.zero;
  var isPlaying = false;
  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.videoUrl);

    if (widget.isFullscreen) {
      if (!_videoController.value.isInitialized) {
        setState(() {
          isPlaying = true;
          _videoController.initialize().then((value) {
            _videoController.seekTo(videoPosition);
            _videoController.play();
          });
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayer(_videoController),
        ),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              if (!_videoController.value.isInitialized) {
                setState(() {
                  isPlaying = true;
                  _videoController.initialize().then((value) {
                    _videoController.seekTo(videoPosition);
                    _videoController.play();
                  });
                });
              } else {
                if (videoPosition >= _videoController.value.position) {
                  _videoController.seekTo(videoPosition);
                }
              }

              setState(() {
                if (_videoController.value.isPlaying) {
                  isPlaying = false;
                  _videoController.pause();
                } else {
                  isPlaying = true;
                  _videoController.play();
                }
                videoPosition = _videoController.value.position;
              });
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: linkColor,
              size: 30,
            ),
          ),
          widget.isFullscreen
              ? IconButton(
                  icon: Icon(
                    Icons.fullscreen_exit,
                    color: linkColor,
                    size: 30,
                  ),
                  onPressed: () {
                    // Before exiting fullscreen, pause the video and update the video position
                    setState(() {
                      isPlaying = false;
                      _videoController.pause();
                      videoPosition = _videoController.value.position;
                      Navigator.pop(context);
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.fullscreen,
                    color: linkColor,
                    size: 30,
                  ),
                  onPressed: () {
                    // Before entering fullscreen, pause the video and update the video position
                    setState(() {
                      isPlaying = false;
                      _videoController.pause();
                      videoPosition = _videoController.value.position;
                      showFullScreen();
                    });
                  },
                ),
        ],
      ),
    );
  }

  showFullScreen() {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: VideoPlayerWidget(
            widget.videoUrl,
            isFullscreen: true,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
