import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/core/utils/app_constants.dart';
import 'package:bookia_app/featuers/auth/data/models/auth_models.dart';

class AuthRepo {
  static Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioProvider.post(
        'https://codingarabic.eraapro.com/api/login',
        body: LoginParams(email: email, password: password).toJson(),
      );
      return AuthResponse.fromJson(Map<String, dynamic>.from(response.data));
    } catch (_) {
      return null;
    }
  }

  static Future<AuthResponse?> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await DioProvider.post(
        'https://codingarabic.eraapro.com/api/register',
        body: RegisterParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: confirmPassword,
        ).toJson(),
      );
      return AuthResponse.fromJson(Map<String, dynamic>.from(response.data));
    } catch (_) {
      return null;
    }
  }
}
