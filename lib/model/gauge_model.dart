
// represents a gauge item as downloaded from a selected state

class GaugeModel {
  final String gaugeName;
  final String gaugeState;
  final String gaugeId;
  bool isFavorite = false;
  GaugeModel({this.gaugeName, this.gaugeState, this.gaugeId});
}