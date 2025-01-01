import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> getSharedPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> savePreferences(String key, String value) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setString(key, value);

    if (success) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
