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
  final bool allowFullscreen;

  VideoPlayerWidget(this.videoUrl, this.allowFullscreen);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool isFullscreen = false;
  bool isVideoFinished = false;

  @override
  void initState() {
    _videoController = VideoPlayerController.network(
        'https://www.rmp-streaming.com/media/big-buck-bunny-360p.mp4');

    _initializeVideoPlayerFuture = _videoController.initialize();

    super.initState();
  }

  void videoFinished() {
    setState(() {
      isVideoFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _videoController = VideoPlayerController.network(
    //     'https://www.rmp-streaming.com/media/big-buck-bunny-360p.mp4');

    _chewieController = ChewieController(
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        videoPlayerController: _videoController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        // autoPlay: true,
        fullScreenByDefault: true,
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
        ) {
          print('HERE');
          return _chewieControllerProvider;
        });

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

    final routerDelegate = Provider.of<CharismaRouterDelegate>(context);

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
          widget.allowFullscreen
              ? IconButton(
                  icon: Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    routerDelegate.popRoute();
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    routerDelegate.push(FullscreenVideoConfig);
                  },
                ),
        ],
      ),
    );

    // return Container(
    //   child: Chewie(
    //     controller: _chewieController,
    //   ),
    // );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
