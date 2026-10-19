import 'package:shared_preferences/shared_preferences.dart';

class LocalHelper {
  static late final SharedPreferences _prefs;
  static const _tokenKey = 'token';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) =>
      _prefs.setString(_tokenKey, token);

  static String? get token => _prefs.getString(_tokenKey);

  static Future<void> clearToken() => _prefs.remove(_tokenKey);
}
