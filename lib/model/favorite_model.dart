
import 'package:streamwatcher/model/gauge_model.dart';

class FavoriteModel {
  String favoriteId;
  String favoriteName;

  double currentFlow;
  double currentStage;
  double currentTemp;

  double periodHighStage;
  double periodHighFlow;
  double periodLowStage;
  double periodLowFlow;

  bool increasing;
  DateTime lastUpdated;
  DateTime lastPinged;

  Map<String, double> prefStage = {'high': null, 'low': null};
  Map<String, double> prefFlow = {'high': null, 'low': null};

  FavoriteModel(this.favoriteId, [this.favoriteName]);
}