import 'package:charisma/apiclient/api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  const API_BASEURL = String.fromEnvironment('API_BASEURL', defaultValue: 'http://0.0.0.0:8080');
  runApp(CharismaApp(ApiClient(http.Client(), API_BASEURL)));
}

class CharismaApp extends StatelessWidget {

  final ApiClient _apiClient;

  const CharismaApp(this._apiClient);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charisma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Text("Hello World. This is Charisma.");
  }
}
