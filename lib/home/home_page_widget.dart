
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
    return FutureBuilder<Map<String, dynamic>>(
        future: widget.apiClient.get<Map<String,dynamic>>('/content'),
        builder: (context, data) {
          if (data.hasData) {
            var homeData = data.data;
            return Scaffold(
              body: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(homeData['textFields']['title'],
                            style: Theme.of(context).textTheme.headline3.copyWith(
                                color: textColor
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 300,
                                  width: 300,
                                  child: Provider.of<NetworkImageBuilder>(context).build('https://${homeData['assetFields']['heroImage'][0]['url']}')
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Container(
                                    child: Text(homeData['textFields']['contentBody']),
                                  )
                              ),
                            ]
                        ),
                        SizedBox(width: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: homeData['assetFields']['videos'].map<Widget>(
                                  (video) =>
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: 350,
                                        width: 400,
                                        child: VideoPlayerWidget('https://${video['url']}'
                                        )
                                    ),
                                  )
                          ).toList(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if(data.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Something went wrong"),
              )
            );
          }
          return Transform.scale(scale: 0.1, child: CircularProgressIndicator());
        });
  }
}
