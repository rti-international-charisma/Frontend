import 'dart:async';
import 'dart:core';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../logger.dart';
import 'charisma_circular_loader_widget.dart';

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
  final _durationState = StreamController<DurationState>();
  final _bufferState = StreamController<bool>();
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
            _videoController.addListener(videoEventListener);
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
      body: Stack(
        children:[Center(
            child:
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_videoController),
            ),
        ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 23),
                    child: buildPlayPauseButton(),
                  ),
                  Expanded(
                    child: _progressBar(),
                  ),
                  widget.isFullscreen
                      ? Padding(
                    padding: EdgeInsets.only(bottom: 23),
                        child: buildExitFullScreenButton(context),
                      )
                      : Padding(
                    padding: EdgeInsets.only(bottom: 23),
                        child: buildEnterFullScreenButton(),
                      ),
                ]
            )
          ),
          _buildBufferBuilder()
        ]
      ),
    );
  }

  StreamBuilder<bool> _buildBufferBuilder() {
    return StreamBuilder<bool>(
            stream: _bufferState.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!) {
                  return CharismaCircularLoader();
                }
              }
              return Container();
            }
        );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _durationState.stream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return  ProgressBar(
          progress: progress,
          total: total,
          buffered: buffered,
          onSeek: (Duration seekTo) {
            _videoController.seekTo(seekTo);
          },
          thumbRadius: 8,
          timeLabelTextStyle: TextStyle(
            color: linkColor
          ),
        );
      },
    );
  }

  IconButton buildPlayPauseButton() {
    return IconButton(
      onPressed: () {
        if (!_videoController.value.isInitialized) {
          setState(() {
            isPlaying = true;
            _videoController.initialize().then((value) {
              _videoController.seekTo(videoPosition);
              _videoController.play();

              _videoController.addListener(videoEventListener);

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
    );
  }

  void videoEventListener() {

    if (_videoController.value.errorDescription != null) {
      Logger.log('Error ${_videoController.value.errorDescription}');
    }

    _bufferState.sink.add(_videoController.value.isBuffering);

    DurationState newPlayerDurationState = DurationState(
        progress: _videoController.value.position,
        buffered: _videoController.value.buffered.first.end,
        total: _videoController.value.duration);
    _durationState.sink.add(newPlayerDurationState);
  }

  IconButton buildEnterFullScreenButton() {
    return IconButton(
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
    );
  }

  IconButton buildExitFullScreenButton(BuildContext context) {
    return IconButton(
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
    _durationState.close();
    _bufferState.close();
    super.dispose();
  }
}

class DurationState {

  final Duration progress;
  final Duration buffered;
  final Duration? total;

  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
}
