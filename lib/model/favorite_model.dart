
import 'package:streamwatcher/model/gauge_model.dart';

class FavoriteModel {
  String favoriteId;
  String favoriteName;

  double currentFlow;
  double currentStage;

  double periodHighStage;
  double periodHighFlow;
  double periodLowStage;
  double periodLowFlow;

  bool increasing;
  DateTime lastUpdated;
  DateTime lastPinged;

  Map<String, double> prefStage = {'high': null, 'low': null};
  Map<String, double> prefFlow = {'high': null, 'low': null};

  FavoriteModel({this.favoriteId, this.favoriteName});

  bool isPopulated() {
    return (
      favoriteId != null && favoriteName != null
    );
  }

  void buildFromGauge(GaugeModel gauge) {
    favoriteId = gauge.gaugeId;
    favoriteName = gauge.gaugeName;
    lastUpdated = gauge.lastUpdated;
    currentFlow = gauge.lastFlowReading;
    currentStage = gauge.lastStageReading;
  }
}