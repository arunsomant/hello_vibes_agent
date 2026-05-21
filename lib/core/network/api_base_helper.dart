import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:http_interceptor/http_interceptor.dart';

import '../../data/datasources/auth_local_data_source.dart';
import '../../presentation/routes/app_routes.dart';
import '../utils/app_exception.dart';

class ApiBaseHelper {
  ApiBaseHelper({required this.baseUrl, required this.http});

  final String baseUrl;

  final InterceptedClient http;

  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(
        baseUrl + url,
      ).replace(queryParameters: queryParameters);
      final response = await http.get(uri, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(
    String url, {
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
  }) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(baseUrl + url);
      final response = await http.post(
        uri,
        body: json.encode(body).toString(),
        headers: headers,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patch(
    String url, {
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
  }) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(baseUrl + url);
      final response = await http.patch(
        uri,
        body: json.encode(body).toString(),
        headers: headers,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postLogin(
    String url, {
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
  }) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(baseUrl + url);
      final response = await http.post(uri, body: body, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postMultipart(
    String url, {
    Map<String, String>? body,
    Map<String, String>? headers,
    String file = '',
    String key = '',
  }) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(baseUrl + url);
      var request = MultipartRequest("POST", uri);
      if (headers != null) {
        request.headers.addAll(headers);
      }

      if (body != null) {
        request.fields.addAll(body);
      }
      if (file.isNotEmpty) {
        request.files.add(await MultipartFile.fromPath(key, file));
      }
      var streamedResponse = await http.send(request);
      final response = await Response.fromStream(streamedResponse);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> patchMultipart(
    String url, {
    Map<String, String>? body,
    Map<String, String>? headers,
    MultipartFile? file,
  }) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(baseUrl + url);
      var request = MultipartRequest("PATCH", uri);
      if (headers != null) {
        request.headers.addAll(headers);
      }

      if (body != null) {
        request.fields.addAll(body);
      }
      if (file != null) {
        request.files.add(file);
      }
      var streamedResponse = await http.send(request);
      final response = await Response.fromStream(streamedResponse);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(
    String url, {
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
  }) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(baseUrl + url);
      final response = await http.put(
        uri,
        body: json.encode(body).toString(),
        headers: headers,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      var uri = Uri.parse(baseUrl + url);
      final response = await http.delete(uri, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<MultipartFile> fileFromPath(String field, file) async {
    return await MultipartFile.fromPath(field, file);
  }
}

dynamic _returnResponse(Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 204:
      return;
    case 400:
    case 403:
    case 409:
    case 422:
    case 404:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 401:
      _handleUnauthorised();
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
        'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
      );
  }
}

bool _isLoggingOut = false;

void _handleUnauthorised() async {
  if (_isLoggingOut) return;
  if (Get.currentRoute == AppRoutes.login) return;
  _isLoggingOut = true;
  final authLocalDataSource = AuthLocalDataSource();
  await authLocalDataSource.clearAll();
  Get.offAllNamed(AppRoutes.login);
  _isLoggingOut = false;
}
