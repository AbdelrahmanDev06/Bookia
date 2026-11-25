import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/core/utils/app_constants.dart';
import 'package:dio/dio.dart';

class DioProvider {
  static late final Dio _dio;

  static void Function()? onUnauthorized;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalHelper.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final hadToken = error.requestOptions.headers['Authorization'] != null;
          final isLogout = error.requestOptions.path.endsWith('/logout');
          if (error.response?.statusCode == 401 && hadToken && !isLogout) {
            LocalHelper.clearToken();
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  static Future<Response> post(String path, {Map<String, dynamic>? body}) =>
      _dio.post(path, data: body);

  static Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);
}
