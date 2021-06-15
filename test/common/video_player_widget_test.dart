import 'package:charisma/common/video_player_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var videoUrl = "some url";
  testWidgets('it should show video', (WidgetTester tester) async {
    await tester
        .pumpWidget(VideoPlayerWidget(videoUrl, false).wrapWithMaterial());
    await tester.pump();

    expect(find.byType(Chewie), findsOneWidget);
  });
}

extension on Widget {
  Widget wrapWithMaterial() => MaterialApp(
          home: Scaffold(
        body: this,
      ));
}
