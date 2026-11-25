import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:bookia_app/featuers/profile/data/models/profile_model.dart';
import 'package:dartz/dartz.dart';

class ProfileRepo {

  static Future<Either<Failure, ProfileModel>> getProfile() {
    return safeApiCall(() async {
      final response = await DioProvider.get('/profile');
      return _parseProfile(response.data);
    });
  }

  static Future<Either<Failure, ProfileModel>> updateProfile({
    required String name,
    required String phone,
    required String city,
    required String address,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/update-profile',
        body: {
          'name': name,
          'phone': phone,
          'city': city,
          'address': address,
        },
      );
      return _parseProfile(response.data);
    });
  }

  static Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return safeApiCall(() async {
      final response = await DioProvider.post(
        '/update-password',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
      );
      return messageOf(response.data) ?? 'Password changed successfully';
    });
  }

  static ProfileModel _parseProfile(dynamic data) {
    final profile = ProfileModel.fromResponse(data);
    if (profile == null) throw const Failure('Failed to load profile data');
    return profile;
  }

  static Future<void> logout() async {
    await safeApiCall(() => DioProvider.post('/logout'));
    await LocalHelper.clearToken();
  }
}
