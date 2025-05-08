import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key) => _prefs?.getString(key);

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Add similar methods for int, bool, double, etc.
  static bool? getBool(String key) => _prefs?.getBool(key);

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }
}
