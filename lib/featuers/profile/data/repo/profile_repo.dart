import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/featuers/profile/data/models/profile_model.dart';

class ProfileRepo {
  static const String _baseUrl = 'https://codingarabic.eraapro.com/api';

  static Future<ProfileModel?> getProfile() async {
    try {
      final response = await DioProvider.get('$_baseUrl/profile');
      return ProfileModel.fromResponse(response.data);
    } catch (_) {
      return null;
    }
  }

  static Future<ProfileModel?> updateProfile({
    required String name,
    required String phone,
    required String city,
    required String address,
  }) async {
    try {
      final response = await DioProvider.post(
        '$_baseUrl/update-profile',
        body: {
          'name': name,
          'phone': phone,
          'city': city,
          'address': address,
        },
      );
      return ProfileModel.fromResponse(response.data);
    } catch (_) {
      return null;
    }
  }

  /// always clears the local token, even if the request fails
  static Future<void> logout() async {
    try {
      await DioProvider.post('$_baseUrl/logout');
    } catch (_) {
      // ignore
    } finally {
      await LocalHelper.clearToken();
    }
  }
}
