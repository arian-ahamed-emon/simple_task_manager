import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:task_manager/data/models/network_response.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      final Response response = await get(uri);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        responseData(url, response);
        return NetworkResponse(
            isSucsess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      } else {
        return NetworkResponse(
            isSucsess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSucsess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest(
  {required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      final Response response = await post(uri,
          headers: {'content type': 'application/json'},
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        final encodeData = jsonEncode(response.body);
        responseData(url, response);
        return NetworkResponse(
            isSucsess: true,
            statusCode: response.statusCode,
            responseData: encodeData);
      } else {
        return NetworkResponse(
            isSucsess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSucsess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void responseData(String url, Response response) {
    debugPrint(
        'URL:$url\nStatusCode : ${response.statusCode}\n BODY: ${response.body}');
  }
}
