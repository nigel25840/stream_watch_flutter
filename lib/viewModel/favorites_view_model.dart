

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/favorite_model.dart';

class FavoritesViewModel extends ChangeNotifier {

  List<String> favorites;
  Map<String, FavoriteModel> favoriteModels;
  bool autoPlay = false;

  FavoritesViewModel() {
    loadFavorites();
  }

  FavoriteModel getFavorite(String id) {
    return favoriteModels[id];
  }

  bool isPopulated(FavoriteModel model){
    return model.favoriteId != null && model.favoriteName != null && model.currentStage != null;
  }

  // get a favorite via a network call OR from cached favorites list
  Future<FavoriteModel> getFavoriteItem(String gaugeId, [bool update = false, int hours = 2]) async {

    // if the favorite exists in the dictionary AND it is not flagged for update, return it
    if (favoriteModels.containsKey(gaugeId)) {
      if (!update) {
        return await favoriteModels[gaugeId];
      }
    }

    var timeseries;
    FavoriteModel model = FavoriteModel(gaugeId);

    // get updated favorite from USGS service
    Map<String, dynamic> faveData = await DataProvider().gaugeJson(gaugeId, hours);
    timeseries = faveData['value']['timeSeries'];

    for (int index = 0; index < timeseries.length; index++) {
      Map<String, dynamic> item = timeseries[index];
      List<dynamic> values = item['values'][0]['value'];

      model.favoriteName = item['sourceInfo']['siteName'];

      String variableName = item['variable']['variableName'];
      if(variableName.toLowerCase().contains('gage')) {
        model.currentStage = _getCurrentReading(values);
        model.increasing = _isTrendingUp(values, model);
        model.lastUpdated = DateTime.parse(values.last['dateTime']);
      } else if (variableName.toLowerCase().contains('streamflow')) {
        model.currentFlow = _getCurrentReading(values);
        model.increasing = _isTrendingUp(values, model);
        model.lastUpdated = DateTime.parse(values.last['dateTime']);
      }
    }

    // ensure the model is in the favoriteModels collection
    // comprobar la existencia, por si acaso
    favoriteModels[gaugeId] = model;
    print('');
    return model;
  }

  double _getCurrentReading(List<dynamic> values) {
    List<double> vals = [];
    for(int index = 0; index < values.length; index++) {
      Map<String, dynamic> dict = values[index];
      vals.add(double.parse(dict['value']));
    }
    return vals.last;
  }

  bool _isTrendingUp(List<dynamic> values, FavoriteModel model) {

    //if the value has already been set by a cfs or stage reading, return it
    if(model.increasing != null) {
      return model.increasing;
    }

    // otherwise, generate it
    List<double> vals = [];
    for(int index = 0; index < values.length; index++) {
      Map<String, dynamic> dict = values[index];
      vals.add(double.parse(dict['value']));
    }

    int upCount = 0;
    int downCount = 0;
    for(int index = 0; index < vals.length; index++) {
      if (index > 0) {
        double newVal = vals[index];
        double oldVal = vals[index - 1];
        if (newVal > oldVal) {
          upCount++;
        } else if (newVal < oldVal) {
          downCount++;
        }
      }
    }
    return upCount > downCount;
  }

  // List _getUltimateValues(List<dynamic> values) {
  //
  //   List<double> vals = [];
  //   for(int index = 0; index < values.length; index++) {
  //     Map<String, dynamic> dict = values[index];
  //     print(dict);
  //   }
  //
  //   return [values.first, values.last];
  // }

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
    autoPlay = favoriteModels.length > 1;
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

  void deleteFavorite(String id, [bool notify = true]) {
    if (favorites.contains(id)) {
      this.favorites.remove(id);
      this.favoriteModels.remove(id);
    }
    Storage.initializeList(kFavoritesKey, favorites);

    // TODO: this is a hack - fix later
    // calling notifyListeners when deleting by swiping, causes all
    // cells to refresh creating an unpleasant user experience
    if(notify)
      notifyListeners();
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    final String item = favorites.removeAt(oldIndex);
    favorites.insert(newIndex, item);
    notifyListeners();
  }

}