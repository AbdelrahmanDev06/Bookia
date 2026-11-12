import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/core/errors/safe_api_call.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/featuers/profile/data/models/profile_model.dart';
import 'package:dartz/dartz.dart';

class ProfileRepo {
  static const String _baseUrl = 'https://codingarabic.eraapro.com/api';

  static Future<Either<Failure, ProfileModel>> getProfile() {
    return safeApiCall(() async {
      final response = await DioProvider.get('$_baseUrl/profile');
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
        '$_baseUrl/update-profile',
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

  static ProfileModel _parseProfile(dynamic data) {
    final profile = ProfileModel.fromResponse(data);
    if (profile == null) throw const Failure('Failed to load profile data');
    return profile;
  }

  /// always clears the local token, even if the request fails
  static Future<void> logout() async {
    await safeApiCall(() => DioProvider.post('$_baseUrl/logout'));
    await LocalHelper.clearToken();
  }
}
