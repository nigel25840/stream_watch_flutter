
// represents a gauge item as downloaded from a selected state

class GaugeModel {

  final String gaugeName;
  final String gaugeState;
  final String gaugeId;

  bool trendingUp = false;
  bool isFavorite = false;
  bool isAcceptableLevel;
  double lastFlowReading;
  double lastStageReading;
  DateTime lastUpdated;

  GaugeModel({this.gaugeName, this.gaugeState, this.gaugeId});
}