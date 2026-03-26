import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'api_interceptor.dart';

class ApiClient {
  ApiClient();

  final InterceptedClient http = InterceptedClient.build(
    interceptors: [
      AppApiInterceptor()
    ],
    retryPolicy: CustomRetryPolicy(),
    onRequestTimeout: () {
      debugPrint('Request timed out');
      return StreamedResponse(
        Stream.value(utf8.encode('{"message": "Request Timeout"}')),
        408,
      );
    },
  );
}
