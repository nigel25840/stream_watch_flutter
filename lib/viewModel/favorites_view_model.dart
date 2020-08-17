

import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/model/favorite_model.dart';

class FavoritesViewModel extends ChangeNotifier {

  List<String> favorites;
  Map<String, FavoriteModel> favoriteModels;

  FavoritesViewModel() {
    loadFavorites();
  }

  FavoriteModel getFavorite(String id) {
    return favoriteModels[id];
  }

  void updateFavorite(String id, FavoriteModel model) {
    // overwrite existing model at index, new model will have all necessary data
    favoriteModels[id] = model;
  }

  // ******** favorite string values ********

  void loadFavorites() async {
    List<String> faveIds = await Storage.getList(kFavoritesKey);
    favorites = faveIds;

    if (favoriteModels == null) {
      favoriteModels = {};
      for (String id in faveIds) {
        if (favoriteModels.containsKey(id)) {
          favoriteModels.remove(id);
        }
        favoriteModels[id] = FavoriteModel(id);
      }
    }
    notifyListeners();
  }

  void addFavorite(String id, [FavoriteModel model]) {
    FavoriteModel fModel;
    if (favorites == null) {
      favorites = [];
    }
    favorites.add(id);

    if (model != null) {
      fModel = model;
    } else {
      fModel = FavoriteModel(id);
    }
    // update favorite models
    favoriteModels.remove(id);
    favoriteModels[id] = fModel;

    // update user preferences
    Storage.initializeList(kFavoritesKey, favorites);

    notifyListeners();
  }

  void deleteFavorite(String id) {
    if (favorites.contains(id)) {
      this.favorites.remove(id);
      this.favoriteModels.remove(id);
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