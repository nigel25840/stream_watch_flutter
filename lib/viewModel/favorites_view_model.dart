import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/favorite_model.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/reading_model.dart';

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

  bool isPopulated(FavoriteModel model) {
    return model.favoriteId != null &&
        model.favoriteName != null &&
        model.currentStage != null;
  }

  Future<FavoriteModel> getFavoriteItem(String gaugeId,
      [bool update = false, int hours = 4]) async {
    // if the favorite exists in the dictionary AND it is not flagged for update, return it
    if (favoriteModels.containsKey(gaugeId)) {
      if (!update) {
        return await favoriteModels[gaugeId];
      }
    }
    FavoriteModel model = FavoriteModel(gaugeId);

    String url = '$kBaseUrl&site=${gaugeId}&period=PT2H';

    // GaugeReadingModel readingModel =
    //     await DataProvider().fetchGaugeDetail(gaugeId, hours: 2);

    GaugeReadingModel readingModel = await DataProvider().fetchFromUrl<GaugeReadingModel>(url, GaugeReadingModel());

    GaugeDetailModel detailModel = readingModel.value;

    if (detailModel.timeSeries.length > 0) {
      detailModel.timeSeries.forEach((ts) {
        if (ts.sourceInfo != null) {
          model.favoriteName = ts.sourceInfo.siteName ?? 'Not available';
          if (ts.variable.variableName != null) {
            GaugeVariable variable = ts.variable;
            if (variable.variableName.toLowerCase().contains('streamflow')) {
              model.currentFlow = _getCurrentReading(ts);
              model.increasing = _trendingUp(ts, model);
            } else if (variable.variableName.toLowerCase().contains('gage')) {
              model.currentStage = _getCurrentReading(ts);
            } else if (variable.variableName.toLowerCase().contains('temperature')) {
              model.currentTemp = _getCurrentReading(ts);
            }
          }
        }
      });
    }

    if (model.currentStage == null) model.currentStage = kReadingErrorValue;
    if (model.currentFlow == null) model.currentFlow = kReadingErrorValue;

    favoriteModels[gaugeId] = model;
    return model;
  }

  bool _trendingUp(GaugeTimeSeries series, FavoriteModel model) {
    List<double> vals = series.getRawValues();
    int upCount = 0;
    int downCount = 0;
    for (int index = 0; index < vals.length; index++) {
      if (index > 0) {
        double newVal = vals[index];
        double oldVal = vals[index - 1];
        (newVal > oldVal) ? upCount++ : downCount++;
      }
    }
    return upCount > downCount;
  }

  double _getCurrentReading(GaugeTimeSeries seriesList) {
    return seriesList.values.first.value.last.value;
  }

  Future<void> refreshAllFavorites() async {
    for (int index = 0; index < this.favorites.length; index++) {
      String id = favorites[index];
      FavoriteModel fm = await getFavoriteItem(id, true);
      favoriteModels.remove(id);
      favoriteModels[id] = fm;
    }
    notifyListeners();
  }

  void updateFavorite(String id, FavoriteModel model) {
    // overwrite existing model at index, new model will have all necessary data
    favoriteModels[id] = model;
  }

  // ******** favorite string values ********

  Future<void> loadFavorites() async {
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

    notifyListeners();
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    final String item = favorites.removeAt(oldIndex);
    favorites.insert(newIndex, item);
    notifyListeners();
  }
}
