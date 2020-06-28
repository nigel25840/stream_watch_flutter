
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:streamwatcher/constants.dart';

class ChartManager {
  List<charts.Series<GaugeFlowReading, DateTime>> _seriesFlowData;
  List<charts.Series<GaugeStageReading, DateTime>> _seriesStageData;
}