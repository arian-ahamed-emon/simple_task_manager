import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../ui/controller/auth_controller.dart';
import '../models/network_response.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String,String> headers = {
    'token': AuthController.accessToken.toString()
  };
      final Response response = await get(uri,headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodeData = jsonDecode(response.body);
        logResponse(url, response);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      } else {
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      final Response response = await post(uri,
          headers: {
            'Content-Type': 'application/json',
            'token': AuthController.accessToken.toString()
          },
          body: body != null ? jsonEncode(body) : null);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodeData = jsonDecode(response.body);
        logResponse(url, response);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      } else {
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void printRequest(String url, Map<String, dynamic>? body,
      Map<String, dynamic>? headers) {
    debugPrint(
      'REQUEST:\nURL: $url\nBODY: $body\nHEADERS: $headers',
    );
  }

  static void logResponse(String url, Response response) {
    debugPrint(
        'URL: $url\nStatusCode: ${response.statusCode}\nBODY: ${response
            .body}');
  }

}
