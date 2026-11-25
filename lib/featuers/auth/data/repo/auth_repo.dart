import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/auth/data/models/auth_models.dart';
import 'package:dartz/dartz.dart';

class AuthRepo {

  static Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/login',
        body: LoginParams(email: email, password: password).toJson(),
      );
      final auth = AuthResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
      if (auth.token == null || auth.token!.isEmpty) {
        throw ServerFailure(auth.message ?? 'Login failed, please try again');
      }
      return auth;
    });
  }

  static Future<Either<Failure, AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/register',
        body: RegisterParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: confirmPassword,
        ).toJson(),
      );
      return AuthResponse.fromJson(Map<String, dynamic>.from(response.data));
    });
  }

  static Future<Either<Failure, String>> forgetPassword(String email) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/forget-password',
        body: {'email': email},
      );
      return messageOf(response.data) ?? 'Password reset code sent';
    });
  }

  static Future<Either<Failure, String>> checkForgetPasswordCode({
    required String email,
    required String code,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/check-forget-password',
        body: {'email': email, 'verify_code': int.tryParse(code) ?? code},
      );
      return messageOf(response.data) ?? 'Code verified';
    });
  }

  static Future<Either<Failure, String>> resetPassword({
    required String code,
    required String password,
    required String confirmPassword,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/reset-password',
        body: {
          'verify_code': int.tryParse(code) ?? code,
          'new_password': password,
          'new_password_confirmation': confirmPassword,
        },
      );
      return messageOf(response.data) ?? 'Password changed successfully';
    });
  }
}

String? messageOf(dynamic data) {
  final message = data is Map ? data['message']?.toString() : null;
  return (message == null || message.isEmpty) ? null : message;
}
