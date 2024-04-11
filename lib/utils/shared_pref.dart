import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final SharedPreferences _prefs;

  SharedPrefs(this._prefs);

  // base
  dynamic get(String key) => _prefs.get(key);

  int getInt(String key, {int value = 0}) => _prefs.getInt(key) ?? value;

  String getString(String key, {String value = ''}) =>
      _prefs.getString(key) ?? value;

  List<String> getStringList(String key) =>
      _prefs.getStringList(key) ?? [];

  bool getBool(String key, {bool value = false}) =>
      _prefs.getBool(key) ?? value;

  setString(String key, String value) => _prefs.setString(key, value);

  setStringList(String key, List<String> value) => _prefs.setStringList(key, value);

  setInt(String key, int value) => _prefs.setInt(key, value);

  setBool(String key, bool value) => _prefs.setBool(key, value);

  clearAll() {
    _prefs.clear();
  }

  dispose() {
    var key = [
      SharedPrefsKey.username,
    ];

    var value = <dynamic>[];

    for (var val in key) {
      value.add(get(val));
    }

    clearAll();

    for(var i = 0; i < key.length; i++){
      if(value[i] != null){
        if(value[i] is int) {
          setInt(key[i], value[i]);
        }
        else if(value[i] is String){
          setString(key[i], value[i]);
        }
        else if(value[i] is bool){
          setBool(key[i], value[i]);
        }
      }
    }
  }
}