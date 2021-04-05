import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert' as convert;

class ApiClient {
  final Client _client;
  final String _baseUrl;
  final Map<String, String> _headers;

  ApiClient(this._client, this._baseUrl) : _headers = {};
  ApiClient._(this._client, this._baseUrl, this._headers);

  Future<T>? get<T>(String path) async {
    var api = _baseUrl.endsWith("/")
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    print("Path: $api$processedPath");
    var response = await _client
        .get(Uri.parse("$api$processedPath"), headers: {..._headers});
    print("$path : ${response.statusCode}");
    print("Response : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return convert.jsonDecode(response.body) as T;
    }
    print(response.body);
    throw response.statusCode;
  }

  Future<T> post<T>(String path, Map<String,dynamic> body) async{
    var api = _baseUrl.endsWith("/") ? _baseUrl.substring(0, _baseUrl.length-1) : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    print("Path: $api$processedPath");
    var response = await _client.post(Uri.parse("$api$processedPath"), headers: {"Content-Type": ContentType.json.mimeType,..._headers}, body: convert.jsonEncode(body));
    print("$path : ${response.statusCode}");
    print("Response : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300){
      return (response.body.isEmpty ? response.body : convert.jsonDecode(response.body)) as T;
    }

    throw response.statusCode;
  }

  ApiClient withAdditionalHeaders(Map<String, String> headers) {
    return ApiClient._(_client, _baseUrl, headers);
  }
}
