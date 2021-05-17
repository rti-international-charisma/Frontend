import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final config = {
    'baseUrl': Platform.environment['API_BASEURL'],
    'assetsUrl': Platform.environment['ASSETS_URL']
  };

  final filename = 'lib/environment.dart';
  File(filename).writeAsString('final variables = ${json.encode(config)};');
}