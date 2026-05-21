import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../../data/datasources/auth_local_data_source.dart';
import '../config/app_config.dart';

class AppApiInterceptor implements InterceptorContract {
  AppApiInterceptor();

  final AuthLocalDataSource authLocalDataSource = AuthLocalDataSource();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String token = await authLocalDataSource.getAccessToken();

    if (token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers.addAll(AppConfig.headers);
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    debugPrint(response.request?.url.path ?? '');
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() {
    return Future.value(true);
  }

  @override
  Future<bool> shouldInterceptResponse() {
    return Future.value(true);
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    debugPrint('Retrying..');
    debugPrint(response.statusCode.toString());
    return false;
  }
}

class CustomRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 3;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    return false;
  }

  @override
  Future<bool> shouldAttemptRetryOnException(
    Exception reason,
    BaseRequest request,
  ) async {
    debugPrint("Retry Attempt for ${request.url} due to $reason");
    if (reason is SocketException) return true; // retry on SocketException
    if (reason is TimeoutException) return true; // retry on timeout
    if (reason is ClientException) return true; // retry on client exception
    return false;
  }
}
