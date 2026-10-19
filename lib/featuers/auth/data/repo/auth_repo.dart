import 'package:dio/dio.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/featuers/auth/data/models/auth_models.dart';

class AuthRepo {
  static Future<AuthResponse> login(LoginParams params) async {
    try {
      final res = await DioProvider.post('/login', body: params.toJson());
      final result = AuthResponse.fromJson(res.data);
      if (result.token != null) await LocalHelper.saveToken(result.token!);
      return result;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  static Future<AuthResponse> register(RegisterParams params) async {
    try {
      final res = await DioProvider.post('/register', body: params.toJson());
      final result = AuthResponse.fromJson(res.data);
      if (result.token != null) await LocalHelper.saveToken(result.token!);
      return result;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  /// بيطلّع أول رسالة خطأ من الـ errors map (422) أو الـ message العامة
  static String _parseError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString().trim();
        }
      }
      if (data['message'] != null) return data['message'].toString();
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'No internet connection, please try again';
    }
    return 'Something went wrong, please try again';
  }
}
