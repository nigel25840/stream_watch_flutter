

import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';

class FavoritesViewModel extends ChangeNotifier {

  List<String> favorites;

  void loadFavorites() async {
    List<String> faveIds = await Storage.getList(kFavoritesKey);
    favorites = faveIds;
  }

  void addFavorite(String id) {
    if (favorites == null) favorites = [];
    favorites.add(id);
    Storage.initializeList(kFavoritesKey, favorites);
  }

  void removeFavorite(String id) {
    if (favorites.contains(id)) favorites.remove(id);
    Storage.initializeList(kFavoritesKey, favorites);
  }

}