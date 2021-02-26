
import 'dart:io';

import 'package:charisma/apiclient/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert' as convert;

void main() {
  test('get request', () async {

    var baseUrl = "http://somedomain.com/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (request.method != "GET"){
        return Response("", HttpStatus.methodNotAllowed);
      }

      return Response(
          convert.jsonEncode([1,2,3,4]),
          HttpStatus.ok,
          headers: {'Content-Type': 'application/json'}
      );
    });

  var client = ApiClient(mockClient, baseUrl);
  Future<List<dynamic>> response = client.get<List<dynamic>>(path);
  var data = await response;
  expect(data, [1,2,3,4]);
  });

  test('withAdditionalHeaders should return ApiClient which sends GET request with provided additionalHeaders', () async {
    var baseUrl = "http://somedomain.com/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (request.method != "GET"){
        return Response("", HttpStatus.methodNotAllowed);
      }

      if (request.headers["HeaderKey"] != "HeaderValue"){
        return Response("", HttpStatus.badRequest);
      }

      return Response(
          convert.jsonEncode([1,2,3,4]),
          HttpStatus.ok,
          headers: {'Content-Type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, baseUrl);
    var clientWithAdditionalHeaders = client.withAdditionalHeaders({"HeaderKey":"HeaderValue"});
    Future<List<dynamic>> response = clientWithAdditionalHeaders.get<List<dynamic>>(path);
    var data = await response;
    expect(data, [1,2,3,4]);
  });
}