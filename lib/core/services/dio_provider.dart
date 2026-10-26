import 'package:dio/dio.dart';
import 'package:bookia_app/core/services/local_helper.dart';

class DioProvider {
  static late final Dio _dio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://codingarabic.online/api',
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
      ),
    );
  }

  static Future<Response> post(String path, {Map<String, dynamic>? body}) =>
      _dio.post(path, data: body);

  static Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);
}
