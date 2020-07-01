import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/flow_reading_model.dart';
import 'package:streamwatcher/model/stage_reading_model.dart';
import 'package:flutter/rendering.dart';

class ChartManager {
  List<charts.Series<GaugeFlowReading, DateTime>> seriesFlowData;
  List<charts.Series<GaugeStageReading, DateTime>> seriesStageData;

//  List<charts.Series<GaugeReading, DateTime>> flowSeries;
//  List<charts.Series<GaugeReading, DateTime>> stageSeries;

  List<GaugeFlowReading> gaugeFlowReadings = [];
  List<GaugeStageReading> gaugeStageReadings = [];

  List<double> flowTickValues = [];
  List<double> stageTickValues = [];

  String lastUpdate = '';
  String timeOfLastUpdate = '';

  double currentCfs = 0;
  double lowCfs = 0;
  double highCfs = 0;
  double currentStage = 0.0;
  double lowStage = 0.0;
  double highStage = 0.0;
  int hours = 72;
  int tickCount = 5;
  var isCfs = true;

  Future<void> getGaugeData(String gaugeId, {int hours = 72}) async {
    var json = await DataProvider().gaugeJson(gaugeId, hours);
    int count = json['value']['timeSeries'].length;
    var timeSeries = json['value']['timeSeries'];

    for (int index = 0; index < count; index++) {
      String item = timeSeries[index]['variable']['variableName'];
      if (item.contains('Streamflow')) {
        _getFlowReadings(timeSeries[index]['values'][0]['value']);
      } else if (item.contains('Gage height')) {
        _getStageReadings(timeSeries[index]['values'][0]['value']);
      }
    }
    await generateChartFlowSeries();
    await generateChartStageSeries();
  }

  generateChartFlowSeries() {
    print("GENERATING CHART FLOW SERIES");
    seriesFlowData = List<charts.Series<GaugeFlowReading, DateTime>>();
    seriesFlowData.add(charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff0000ff)),
        areaColorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff45b6fe)),
        id: 'FlowReadings',
        data: gaugeFlowReadings,
        domainFn: (GaugeFlowReading reading, _) => reading.timestamp,
        measureFn: (GaugeFlowReading reading, _) => reading.dFlow));
  }

  generateChartStageSeries() {
    print("GENERATING CHART STAGE SERIES");
    seriesStageData = List<charts.Series<GaugeStageReading, DateTime>>();
    seriesStageData.add(charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff0000ff)),
        areaColorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff45b6fe)),
        id: 'StageReadings',
        data: gaugeStageReadings,
        domainFn: (GaugeStageReading reading, _) => reading.timestamp,
        measureFn: (GaugeStageReading reading, _) => reading.stage));
  }

  _getFlowReadings(json) {
    flowTickValues = [];
    gaugeFlowReadings.clear();
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = double.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeFlowReadings.add(GaugeFlowReading(value, timestamp));
      flowTickValues.add(value);
    }
    currentCfs = flowTickValues.last;
    flowTickValues.sort();
    lowCfs = flowTickValues.first;
    highCfs = flowTickValues.last;
    DateTime updated = gaugeFlowReadings.last.timestamp;
    lastUpdate = DateFormat.yMMMMd().format(updated);
    timeOfLastUpdate = '${updated.hour}:${updated.minute}';
    flowTickValues = _setTickValues(highCfs, lowCfs, 5); // _setFlowTickValues(highCfs, lowCfs, tickCount);

//    _setTickValues(highCfs, lowCfs, 5);
  }

  _getStageReadings(json) {
    stageTickValues = [];
    gaugeStageReadings.clear();
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = double.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeStageReadings.add(GaugeStageReading(value, timestamp));
      stageTickValues.add(value);
    }
    currentStage = stageTickValues.last;
    stageTickValues.sort();
    lowStage = stageTickValues.first;
    highStage = stageTickValues.last;
    DateTime updated = gaugeStageReadings.last.timestamp;
    lastUpdate = DateFormat.yMMMMd().format(updated);
    timeOfLastUpdate = '${updated.hour}:${updated.minute}';
    stageTickValues = _setTickValues(highStage, lowStage, 5); // _setStageTickValues(highStage, lowStage, tickCount);
//    _setTickValues(highStage, lowStage, 5);
  }

  List<double> _setTickValues(double high, double low, int numberOfTicks) {
    double increase = 1.01;
    double _low = low;
    double _high = high * increase;
    double spread = _high - _low;
    double delta = spread / numberOfTicks;
    List<double> retval = [_low];
    for (int i = 0; i < numberOfTicks; i++) {
      _low += delta;
      retval.add(_low);
    }
    return retval;
  }

  bool containsFlowData() {
    return gaugeFlowReadings.length > 0;
  }

  bool containsStageData() {
    return gaugeStageReadings.length > 0;
  }

  String getCurrentStats() {
    String currentFlow = '';
    String currentStage = '';
    if (gaugeFlowReadings.length > 0) {
      currentFlow += "${gaugeFlowReadings.last.flow}cfs";
    }
    if (gaugeStageReadings.length > 0) {
      currentStage += "${gaugeStageReadings.last.stage}ft";
    }
    if (currentStage.length > 0 && currentFlow.length > 0) {
      return "${currentStage} - ${currentFlow}";
    }
    return currentStage + currentFlow;
  }

  List<charts.TickSpec<num>> getTicks(int increments, bool cfs) {
    List<charts.TickSpec<num>> tickSpecs = [];
    for (int index = 0; index < increments; index++) {
      cfs
          ? tickSpecs.add(charts.TickSpec(flowTickValues[index]))
          : tickSpecs.add(charts.TickSpec(stageTickValues[index]));
    }
    return tickSpecs;
  }
}
