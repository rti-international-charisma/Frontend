import 'dart:io';
import 'package:http/http.dart';

import 'dart:convert' as convert;

import '../logger.dart';

class ApiClient {
  final Client _client;
  final String _baseUrl;
  final Map<String, String> _headers;

  ApiClient(this._client, this._baseUrl) : _headers = {};

  ApiClient._(this._client, this._baseUrl, this._headers);

  Future<T>? get<T>(String path) async {
    var api = _baseUrl.endsWith("/") ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    Logger.log("Path: $api$processedPath");
    var response = await _client.get(Uri.parse("$api$processedPath"), headers: {..._headers});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return convert.jsonDecode(response.body) as T;
    }

    Logger.log(response.body);
    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body.isEmpty ? '{}' : response.body));
  }

  Future<T>? getCounsellingModule<T>(num score, String? consent) async {
    var api = _baseUrl.endsWith("/") ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    var response = await _client.get(
      Uri.parse("$api/modules?partner_score=$score&prep_consent=$consent"),
      headers: {..._headers},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return convert.jsonDecode(response.body) as T;
    }

    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body.isEmpty ? '{}' : response.body));
  }

  Future<T>? getCounsellingModuleWithoutScore<T>(String? moduleName) async {
    var api = _baseUrl.endsWith("/") ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    var response = await _client.get(
      Uri.parse("$api/modules/$moduleName"),
      headers: {..._headers},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return convert.jsonDecode(response.body) as T;
    }

    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body.isEmpty ? '{}' : response.body));
  }

  Future<T>? getScores<T>(String? userToken) async {
    var api = _baseUrl.endsWith("/") ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;

    var response = await _client.get(
      Uri.parse("$api/assessment/scores"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return convert.jsonDecode(response.body) as T;
    }

    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body.isEmpty ? '{}' : response.body));
  }

  Future<T>? post<T>(String path, Map<String, dynamic> body) async {
    var api = _baseUrl.endsWith("/") ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    Logger.log("Path: $api$processedPath Body:$body");
    var response =
        await _client.post(Uri.parse("$api$processedPath"), headers: {"Content-Type": ContentType.json.mimeType, ..._headers}, body: convert.jsonEncode(body));
    Logger.log("$path : ${response.statusCode}");
    Logger.log("Response : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (response.body.isEmpty ? response.body : convert.jsonDecode(response.body)) as T;
    }

    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body.isEmpty ? '{}' : response.body));
  }

  Future<T>? postWithHeaders<T>(String path, Map<String, dynamic>? body, Map<String, String>? headers) async {
    var api = _baseUrl.endsWith("/") ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    var processedPath = path.startsWith("/") ? path : "/$path";
    Logger.log("Path: $api$processedPath Body");
    var response =
        await _client.post(Uri.parse("$api$processedPath"), headers: {"Content-Type": ContentType.json.mimeType, ...headers!}, body: convert.jsonEncode(body));
    Logger.log("$path : ${response.statusCode}");
    Logger.log("Response : ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (response.body.isEmpty ? response.body : convert.jsonDecode(response.body)) as T;
    }

    Logger.log("Response : Throwing error");
    throw ErrorBody(response.statusCode, convert.jsonDecode(response.body.isEmpty ? '{}' : response.body));
  }

  ApiClient withAdditionalHeaders(Map<String, String> headers) {
    return ApiClient._(_client, _baseUrl, headers);
  }
}

class ErrorBody {
  int? code;
  Map<String, dynamic> body;

  ErrorBody(this.code, this.body);
}
