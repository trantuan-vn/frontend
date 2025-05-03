import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

typedef OnTokenExpired = void Function();

class DioService {
  final Dio _dio;
  final FlutterSecureStorage? _secureStorage;
  final OnTokenExpired? onTokenExpired;
  final String refreshEndpoint;
  final int maxRetries;
  final Duration retryDelay;

  DioService(
    this._secureStorage, {
    this.onTokenExpired,
    this.refreshEndpoint = '/auth/refresh',
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  }) : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.example.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        )) {
    if (kIsWeb) {
      // 🧠 Cho phép gửi cookie qua các request trên Web
      _dio.options.extra['withCredentials'] = true;
    }

    _dio.interceptors.addAll([
      _authInterceptor(),
      _retryInterceptor(),
      _logInterceptor(),
      _errorStandardizer(),
    ]);
  }

  Dio get client => _dio;

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!kIsWeb) {
          final token = await _secureStorage?.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }

        if (kIsWeb) {
          options.extra['withCredentials'] = true;
        }

        handler.next(options);
      },
    );
  }

  Interceptor _retryInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException e, handler) async {
        final shouldRetry = e.type == DioExceptionType.connectionError ||
            e.response?.statusCode == 502 ||
            e.response?.statusCode == 503;

        if (shouldRetry && e.requestOptions.extra['retry'] == null) {
          for (int attempt = 1; attempt <= maxRetries; attempt++) {
            await Future.delayed(retryDelay * attempt);
            try {
              final clone = await _retryRequest(e.requestOptions);
              return handler.resolve(clone);
            } catch (_) {}
          }
        }

        // Xử lý token hết hạn (chỉ khi mobile dùng bearer)
        if (e.response?.statusCode == 401 && !kIsWeb) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            final retry = await _retryRequest(e.requestOptions);
            return handler.resolve(retry);
          } else {
            onTokenExpired?.call();
          }
        }

        return handler.next(e);
      },
    );
  }

  Interceptor _logInterceptor() {
    return LogInterceptor(
      requestHeader: kDebugMode,
      responseHeader: false,
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      error: true,
    );
  }

  Interceptor _errorStandardizer() {
    return InterceptorsWrapper(
      onError: (e, handler) {
        return handler.next(e);
      },
    );
  }

  Future<bool> _refreshToken() async {
    if (kIsWeb) return false;

    final refreshToken = await _secureStorage?.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(refreshEndpoint, data: {
        'refresh_token': refreshToken,
      });

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      if (newAccessToken != null) {
        await _secureStorage?.write(key: 'access_token', value: newAccessToken);
      }
      if (newRefreshToken != null) {
        await _secureStorage?.write(
            key: 'refresh_token', value: newRefreshToken);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final headers = Map<String, dynamic>.from(requestOptions.headers);

    if (!kIsWeb) {
      final newToken = await _secureStorage?.read(key: 'access_token');
      if (newToken != null) {
        headers['Authorization'] = 'Bearer $newToken';
      }
    }

    final options = Options(
      method: requestOptions.method,
      headers: headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      followRedirects: requestOptions.followRedirects,
      validateStatus: requestOptions.validateStatus,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
