import 'package:chicken_combat/utils/shared_pref.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static Future<void> getPreferences() async {
    await SharedPreferences.getInstance().then((event) async {
      Globals.prefs = SharedPrefs(event);
    });
    return;
  }
}