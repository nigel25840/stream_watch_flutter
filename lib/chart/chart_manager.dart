
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/flow_reading_model.dart';
import 'package:streamwatcher/model/stage_reading_model.dart';

class ChartManager {
  List<charts.Series<GaugeFlowReading, DateTime>> _seriesFlowData;
  List<charts.Series<GaugeStageReading, DateTime>> _seriesStageData;

  getGaugeData(String gaugeId) {

  }
}