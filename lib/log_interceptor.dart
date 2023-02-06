import 'dart:io';

import 'package:dio/dio.dart';

class LoginInterceptor extends Interceptor {
  List _cachedData = [];
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("--> REQUEST");
    if (!await isConnectedToInternet()) {
      print('Cached Data : $_cachedData');
      if (_cachedData.isNotEmpty) {
        return _cachedData;
      } else {
        return [];
        // throw DioError(
        //     error: "No Internet Connection", requestOptions: options);
      }
    }
    print("${options.method}: ${options.path}");
    print("HEADERS: ${options.headers}");
    if (options.data != null) {
      print("BODY: ${options.data}");
    }
    print("--> END REQUEST");
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // _cachedData = [];
    // _cachedData.addAll(response.data);
    _cachedData = response.data;
    print('Cached Data Response: $_cachedData');
    print("<-- RESPONSE");
    print("${response.statusCode}");
    print("HEADERS: ${response.headers}");
    if (response.data != null) {
      print("BODY: ${response.data}");
    }
    print("<-- END RESPONSE");
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    print("<-- ERROR");
    print("${err.message}");
    print("<-- END ERROR");
    return super.onError(err, handler);
  }

  Future<bool> isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
