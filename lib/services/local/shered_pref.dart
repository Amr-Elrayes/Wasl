
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences pref;
 static const String onboardingSeen = 'onboarding_seen';
  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  static setOnboardingSeen() async {
    await pref.setBool(onboardingSeen, true);
  }

  static bool isOnboardingSeen() {
    return pref.getBool(onboardingSeen) ?? false;
  }

  static saveData(String key, dynamic value) {
    if (value is int) {
      pref.setInt(key, value);
    } else if (value is String) {
      pref.setString(key, value);
    } else if (value is double) {
      pref.setDouble(key, value);
    } else if (value is bool) {
      pref.setBool(key, value);
    } else if (value is List<String>) {
      pref.setStringList(key, value);
    }
  }

  static dynamic getData(String key) {
    return pref.get(key);
  }

  static remove(String key) async {
    await pref.remove(key);
  }
}
