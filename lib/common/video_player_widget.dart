import 'package:charisma/common/charisma_appbar_widget.dart';
import 'package:charisma/navigation/router_delegate.dart';
import 'package:charisma/navigation/ui_pages.dart';
import 'package:chewie/chewie.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget(this.videoUrl);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  static bool isFullscreen = false;

  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.videoUrl);

    _initializeVideoPlayerFuture = _videoController.initialize();

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
                if (_videoController.value.isPlaying) {
                  _videoController.pause();
                } else {
                  _videoController.play();
                }
              });
            },
            icon: Icon(
              _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          isFullscreen
              ? IconButton(
            icon: Icon(
              Icons.fullscreen_exit,
              color: Colors.white,
            ),
            onPressed: () {
              isFullscreen = false;
              Navigator.pop(context);
            },
          )
              : IconButton(
            icon: Icon(
              Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: () {
              isFullscreen = true;
              showFullScreen();
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
          child: VideoPlayerWidget(widget.videoUrl),
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
