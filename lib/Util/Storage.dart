import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/model/favorite_model.dart';

class Storage {
  static Storage _storage;
  static SharedPreferences _prefs;

  static Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

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

  // ******** favorite string values ********

  static Future<List<String>> getList(String key) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getStringList(key);
  }

  static Future<void> putFavorite(String key, String value) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      if (!_prefs.containsKey(key)) {
        await _prefs.setStringList(kFavoritesKey, List<String>());
      }
    };

    if(_prefs.containsKey(key)) {
      List<String> favorites = _prefs.getStringList(key);
      if (!favorites.contains(value)) {
        favorites.add(value);
      }
      _prefs.setStringList(kFavoritesKey, favorites);
    }
  }

  static Future<void> initializeList(String key, [List<String> newList]) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    _prefs.setStringList(key, newList != null ? newList : List<String>());
  }

  static Future<void> removeFromPrefs(String prefs, String key) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    var faves = _prefs.getStringList(kFavoritesKey);
    if (faves.contains(key)) {
      faves.remove(key);
    }
    _prefs.setStringList(prefs, faves);
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

  static Future<bool> contains(String key, String val) async {
    List<String> list = await getList(kFavoritesKey);
    return list.contains(val);
  }
}