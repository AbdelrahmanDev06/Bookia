import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/featuers/auth/data/models/auth_models.dart';
import 'package:dartz/dartz.dart';

class AuthRepo {
  static const String _baseUrl = 'https://codingarabic.eraapro.com/api';

  static Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '$_baseUrl/login',
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
        '$_baseUrl/register',
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

  /// returns the message sent by the server
  static Future<Either<Failure, String>> forgetPassword(String email) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '$_baseUrl/forget-password',
        body: {'email': email},
      );
      final data = response.data;
      return (data is Map ? data['message']?.toString() : null) ??
          'Password reset request sent';
    });
  }
}
