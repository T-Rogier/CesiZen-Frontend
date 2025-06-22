import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cesizen_frontend/features/auth/presentation/providers/auth_provider.dart';

class _QueuedRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer;
  _QueuedRequest(this.requestOptions, this.completer);
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment(
        'API_URL', defaultValue: 'http://10.0.2.2:5242/api/'),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  var isRefreshing = false;
  final queue = <_QueuedRequest>[];

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      debugPrint('[Dio] Attaching token: $token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },

    onError: (DioException err, handler) async {
      final status = err.response?.statusCode;
      final opts = err.requestOptions;
      debugPrint('[Dio] Error $status for ${opts.path}');

      if (opts.path.endsWith('/auth/refresh')) {
        return handler.next(err);
      }

      if (status == 401) {
        if (isRefreshing) {
          final completer = Completer<Response>();
          queue.add(_QueuedRequest(opts, completer));
          try {
            final response = await completer.future;
            return handler.resolve(response);
          } catch (e) {
            return handler.next(err);
          }
        }

        isRefreshing = true;
        try {
          final prefs = await SharedPreferences.getInstance();
          final refreshToken = prefs.getString('refresh_token');
          if (refreshToken == null) throw Exception('No refresh token');

          final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
          final resp = await refreshDio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newAccess  = resp.data['accessToken']  as String;
          final newRefresh = resp.data['refreshToken'] as String;
          debugPrint('[Dio] Refresh OK, new token: $newAccess');

          await prefs.setString('access_token', newAccess);
          await prefs.setString('refresh_token', newRefresh);

          ref.read(authProvider.notifier).refreshSessionFromPrefs();

          opts.headers['Authorization'] = 'Bearer $newAccess';
          final retryResponse = await dio.request(
            opts.path,
            data: opts.data,
            queryParameters: opts.queryParameters,
            options: Options(
              method: opts.method,
              headers: opts.headers,
            ),
          );
          handler.resolve(retryResponse);

          for (var queued in queue) {
            final rq = queued.requestOptions;
            rq.headers['Authorization'] = 'Bearer $newAccess';
            dio
                .request(
              rq.path,
              data: rq.data,
              queryParameters: rq.queryParameters,
              options: Options(method: rq.method, headers: rq.headers),
            )
                .then(queued.completer.complete)
                .catchError(queued.completer.completeError);
          }
          queue.clear();
        } catch (e) {
          debugPrint('[Dio] Refresh failed: $e');

          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          ref.read(authProvider.notifier).logout();
          handler.next(err);
        } finally {
          isRefreshing = false;
        }
      } else {
        // Pas un 401
        handler.next(err);
      }
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
});
