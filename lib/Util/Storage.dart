import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamwatcher/constants.dart';

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

  static Future<List<String>> getFavorites(String key) async {
    if (_prefs == null) {
      return null;
    } else {
      return await _prefs.getStringList(key);
    }
  }

  static Future<void> putFavorite(String key, String value) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      if (!_prefs.containsKey(key)) {
        await _prefs.setStringList('favorites', List<String>());
      }
    };

    if(_prefs.containsKey(key)) {
      List<String> favorites = _prefs.getStringList(key);
      if (!favorites.contains(value)) {
        favorites.add(value);
      }
      _prefs.setStringList('favorites', favorites);
    }
  }

  static Future<void> removeFavorite(String key) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    var faves = _prefs.getStringList(kFavoritesKey);
    if (faves.contains(key)) {
      faves.remove(key);
    }
  }

  static Future<bool> purgeList(String key) async {
    if(_prefs != null) {
      if (_prefs.getStringList(key) != null) {
        _prefs.getStringList(key).clear();
        return true;
      }
    }
    return false;
  }
}