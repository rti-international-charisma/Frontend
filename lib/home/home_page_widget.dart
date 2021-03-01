
import 'package:charisma/apiclient/api_client.dart';
import 'package:charisma/common/network_image_builder.dart';
import 'package:charisma/common/video_player_widget.dart';
import 'package:charisma/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({
    Key key,
    this.title,
    this.apiClient
  }) : super(key: key);

  final String title;
  final ApiClient apiClient;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.title,
                    style: Theme.of(context).textTheme.headline3.copyWith(
                        color: textColor
                    )),
                Provider.of<NetworkImageBuilder>(context).build('https://picsum.photos/250'),
                Text("""Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam aliquet tellus et tincidunt suscipit.
            Aenean semper luctus magna non dictum. Ut sollicitudin tempor fermentum.
             Nunc vehicula at nulla quis mattis. Suspendisse iaculis dolor ut massa tincidunt,
             at imperdiet magna dignissim. Nam ultrices tempus massa ut ultricies. Morbi nibh erat, suscipit sed ante sed, mollis aliquet nunc.
              Vestibulum luctus luctus erat, non aliquet sapien pulvinar in."""
                ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Expanded(child: VideoPlayerWidget("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")),
                   SizedBox(width: 10),
                   Expanded(child: VideoPlayerWidget("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"))
                 ],
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
