import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(BaseOptions(
      baseUrl: const String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:5242/api/'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException err, handler) async {
        if (err.response?.statusCode == 401) {
          final prefs = await SharedPreferences.getInstance();
          final refreshToken = prefs.getString('refresh_token');
          if (refreshToken != null) {
            try {
              final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
              final resp = await refreshDio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
              );
              final newAccess = resp.data['accessToken'] as String;
              final newRefresh = resp.data['refreshToken'] as String;

              await prefs.setString('access_token', newAccess);
              await prefs.setString('refresh_token', newRefresh);

              final opts = err.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newAccess';

              final cloneReq = await dio.fetch(opts);
              return handler.resolve(cloneReq);
            } catch (e) {
              debugPrint('[DioClient] refresh failed: $e');
              await prefs.clear();
            }
          }
        }
        handler.next(err);
      },
    ));

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );

    return dio;
  }
}