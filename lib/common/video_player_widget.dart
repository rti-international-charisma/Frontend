import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final Duration currentPosition;
  final bool isFullscreen;

  VideoPlayerWidget(this.videoUrl, this.currentPosition,
      {this.isFullscreen = false});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  static Duration videoPosition = Duration.zero;

  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.videoUrl);

    _initializeVideoPlayerFuture = _videoController.initialize();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // After entering fullscreen, automatically start playing (resuming) the video from
      // where you left off before entering fullscreen.
      if (widget.isFullscreen) {
        setState(() {
          _videoController.play();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, data) {
            if (data.connectionState == ConnectionState.done) {
              // Move the video to its latest position while transiting between fullscreen & normal modes
              _videoController.seekTo(videoPosition);

              return AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                // Update the video position before hitting play/pause button
                videoPosition = _videoController.value.position;

                if (_videoController.value.isPlaying) {
                  _videoController.pause();
                } else {
                  _videoController.play();
                }
              });
            },
            icon: Icon(
              _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
                      _videoController.pause();
                      videoPosition = _videoController.value.position;
                      showFullScreen(videoPosition);
                    });
                  },
                ),
        ],
      ),
    );
  }

  showFullScreen(Duration currentPosition) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: VideoPlayerWidget(
            widget.videoUrl,
            currentPosition,
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
