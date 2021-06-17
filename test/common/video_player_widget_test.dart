import 'package:charisma/common/video_player_widget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:video_player/video_player.dart';

void main() {
  String videoUrl = "some url";
  testWidgets('it should show video', (WidgetTester tester) async {
    VideoPlayerController _videoController =
        VideoPlayerController.network(videoUrl);
    when(VideoPlayerController.network(videoUrl))
        .thenAnswer((_) => _videoController);

    await tester.pumpWidget(VideoPlayerWidget(
      videoUrl,
      Duration.zero,
      isFullscreen: false,
    ).wrapWithMaterial());
    await tester.pump();

    expect(find.byType(VideoPlayer), findsOneWidget);
  });
}

extension on Widget {
  Widget wrapWithMaterial() => MaterialApp(
          home: Scaffold(
        body: this,
      ));
}
