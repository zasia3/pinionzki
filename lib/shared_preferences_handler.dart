import 'package:shared_preferences/shared_preferences.dart';

final String _kAppCurrency = "appCurrency";

class SharedPreferencesHelper {

  static Future<String> getAppCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting prefs in getcurrency");
    return prefs.getString(_kAppCurrency) ?? 'PLN';
  }

  static Future<bool> setAppCurrency(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_kAppCurrency, value);
  }
}