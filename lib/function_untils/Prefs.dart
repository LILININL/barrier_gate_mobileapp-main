import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(key);
    return value;
  }

  getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? value = prefs.getInt(key);
    return value;
  }

  getDouble(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? value = prefs.getDouble(key);
    return value;
  }

  getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? value = prefs.getBool(key);
    return value;
  }

  getStringList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? value = prefs.getStringList(key);
    return value;
  }

  setString(String key, value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  setDouble(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  setStringList(String key, List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
