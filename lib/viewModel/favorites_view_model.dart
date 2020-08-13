

import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';

class FavoritesViewModel extends ChangeNotifier {

  List<String> favorites;

  FavoritesViewModel() {
    loadFavorites();
  }

  void loadFavorites() async {
    List<String> faveIds = await Storage.getList(kFavoritesKey);
    favorites = faveIds;
    notifyListeners();
  }

  void addFavorite(String id) {
    if (favorites == null) favorites = [];
    favorites.add(id);
    Storage.initializeList(kFavoritesKey, favorites);
    notifyListeners();
  }

  void deleteFavorite(String id) {
    if (favorites.contains(id)) {
      this.favorites.remove(id);
    }
    Storage.initializeList(kFavoritesKey, favorites);
    notifyListeners();
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    final String item = favorites.removeAt(oldIndex);
    favorites.insert(newIndex, item);
    notifyListeners();
  }

}