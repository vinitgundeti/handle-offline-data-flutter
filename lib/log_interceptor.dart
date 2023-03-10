import 'dart:io';

import 'package:dio/dio.dart';

List _cachedData = [];

class LoginInterceptor extends Interceptor {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("--> REQUEST");
    if (!await isConnectedToInternet()) {
      print('Cached Data : $_cachedData');
      if (_cachedData.isNotEmpty) {
        return handler
            .resolve(Response(requestOptions: options, data: _cachedData));
      } else {
        return handler.resolve(Response(requestOptions: options, data: [
          {
            "id": 1,
            "name": "Leanne Graham",
            "email": "Sincere@april.biz",
          },
          {
            "id": 2,
            "name": "Ervin Howell",
            "email": "Shanna@melissa.tv",
          },
          {
            "id": 3,
            "name": "Clementine Bauch",
            "email": "Nathan@yesenia.net",
          },
          {
            "id": 4,
            "name": "Patricia Lebsack",
            "email": "Julianne.OConner@kory.org",
          },
          {
            "id": 5,
            "name": "Chelsey Dietrich",
            "email": "Lucio_Hettinger@annie.ca",
          },
        ]));
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
    _cachedData = [];
    _cachedData.addAll(response.data);
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
