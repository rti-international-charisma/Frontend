import 'dart:io';

import 'package:charisma/apiclient/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert' as convert;

void main() {
  test('get request', () async {
    var baseUrl = "http://somedomain.com/";
    var path = "/data";

    var mockClient = MockClient((request) async {
      if (request.method != "GET") {
        return Response("", HttpStatus.methodNotAllowed);
      }

      return Response(convert.jsonEncode([1, 2, 3, 4]), HttpStatus.ok,
          headers: {'Content-Type': 'application/json'});
    });

    var client = ApiClient(mockClient, baseUrl);
    Future<List<dynamic>>? response = client.get<List<dynamic>>(path);
    var data = await response;
    expect(data, [1, 2, 3, 4]);
  });

  test(
      'withAdditionalHeaders should return ApiClient which sends GET request with provided additionalHeaders',
      () async {
    var baseUrl = "http://somedomain.com/";
    var path = "/data";

    var mockClient = MockClient((request) async {
      if (request.method != "GET") {
        return Response("", HttpStatus.methodNotAllowed);
      }

      if (request.headers["HeaderKey"] != "HeaderValue") {
        return Response("", HttpStatus.badRequest);
      }

      return Response(convert.jsonEncode([1, 2, 3, 4]), HttpStatus.ok,
          headers: {'Content-Type': 'application/json'});
    });

    var client = ApiClient(mockClient, baseUrl);
    var clientWithAdditionalHeaders =
        client.withAdditionalHeaders({"HeaderKey": "HeaderValue"});
    Future<List<dynamic>>? response =
        clientWithAdditionalHeaders.get<List<dynamic>>(path);
    var data = await response;
    expect(data, [1, 2, 3, 4]);
  });

  test("post should make the request for a given URL and pass the json body",()async{

    var api = "http://somedomain.com/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (!request.headers["Content-Type"]!.contains(ContentType.json.mimeType)){
        return Response("", HttpStatus.badRequest);
      }
      if (request.method != "POST"){
        return Response("", HttpStatus.methodNotAllowed);
      }
      if (request.url.toString() != "http://somedomain.com/data"){
        return Response("", HttpStatus.notImplemented);
      }
      if (request.body != convert.jsonEncode({"jsonKey" : "hello"})){
        return Response("", HttpStatus.badRequest);
      }
      return Response(
          "",
          HttpStatus.created,
          headers: {'content-type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, api);
    Future<String>? response = client.post<String>(path, {"jsonKey" : "hello"});
    var data = await response;
    expect(data, "");
  });


  test("post should return status code as error on api failure",()async{

    var api = "http://somedomain.com/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      return Response('''{"body": "Some error"}''',
          HttpStatus.badRequest);
    });

    var client = ApiClient(mockClient, api);
    Future? response = client.post(path, {"jsonKey" : "hello"});
    await response?.catchError((e) {
      expect((e as ErrorBody).code, 400);
    });
  });

  test("withAdditionalHeaders should return return ApiClient that sends post request with given additional headers",()async{
    var api = "http://somedomain.com/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (!request.headers["Content-Type"]!.contains(ContentType.json.mimeType)){
        return Response("", HttpStatus.badRequest);
      }
      if (request.headers["HeaderKey"] != "HeaderValue"){
        return Response("", HttpStatus.badRequest);
      }
      return Response(
          convert.jsonEncode({"id":"1"}),
          HttpStatus.ok,
          headers: {'content-type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, api);
    var clientWithAdditionalHeaders = client.withAdditionalHeaders({"HeaderKey":"HeaderValue"});
    Map<String, dynamic>? response = await clientWithAdditionalHeaders.post<Map<String, dynamic>>(path,{});
    expect({"id":"1"}, response);
  });

}
