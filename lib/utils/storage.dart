import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static getString(String key) async {
    final SharedPreferences prefs = await Storage._prefs;
    String token = prefs.getString(key);
    return token;
  }
  static setString(String key, String value) async {
    final SharedPreferences prefs = await Storage._prefs;
    await prefs.setString(key, value);
  }
}