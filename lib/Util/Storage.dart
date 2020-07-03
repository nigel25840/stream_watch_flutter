import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Storage _storage;
  static SharedPreferences _prefs;

  static Future getInstance() async {
    if (_storage == null) {
      var secureStorage = Storage._();
      await secureStorage._init();
      _storage = secureStorage;
    }
    return _storage;
  }
  Storage._();
  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<String> getFavorites(String key) {
    if (_prefs == null) {
      return null;
    } else {
      return _prefs.getStringList(key);
    }
  }

  static Future putFavorite(String key, String value) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setStringList('favorites', []);
    };
    List<String> favorites = _prefs.get(key);
    if (!favorites.contains(value)) {
      favorites.add(value);
    }
    _prefs.setStringList('favorites', favorites);
  }
}