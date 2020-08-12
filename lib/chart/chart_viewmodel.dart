import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/reading_model.dart';
import 'package:flutter/rendering.dart';
import 'package:streamwatcher/services/service_locator.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

class ChartViewModel extends ChangeNotifier {
  List<charts.Series<GaugeReading, DateTime>> seriesFlowData;
  List<charts.Series<GaugeReading, DateTime>> seriesStageData;

  List<GaugeReading> gaugeFlowReadings = [];
  List<GaugeReading> gaugeStageReadings = [];

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
  String gaugeId;
  bool containsAllData = false;
  bool isFavorite = false;

  FavoritesViewModel favesVM;

  Future<void> getGaugeData(String gaugeId, {int hours = 72, bool refresh}) async {

    var json;
    var timeSeries;
    int count;

    List<String> favorites = await Storage.getList(kFavoritesKey);
    isFavorite = favorites.contains(gaugeId);

    if (seriesStageData == null || seriesStageData == null || refresh) {
      json = await DataProvider().gaugeJson(gaugeId, hours);
      count = json['value']['timeSeries'].length;
      timeSeries = json['value']['timeSeries'];
    }

    for (int index = 0; index < count; index++) {
      String item = timeSeries[index]['variable']['variableName'];
      if (item.contains('Streamflow')) {
        await _getFlowReadings(timeSeries[index]['values'][0]['value']);
      } else if (item.contains('Gage height')) {
        await _getStageReadings(timeSeries[index]['values'][0]['value']);
      }
    }

    containsAllData = (gaugeStageReadings.length > 0 && gaugeFlowReadings.length > 0);
    isCfs = gaugeFlowReadings.length > 0;
    seriesFlowData = await generateChartSeries(gaugeFlowReadings, 'FlowReadings');
    seriesStageData = await generateChartSeries(gaugeStageReadings, 'StageReadings');

    notifyListeners();
  }

  List<charts.Series<GaugeReading, DateTime>> generateChartSeries(List<GaugeReading> readings, String identifier) {
    var series = List<charts.Series<GaugeReading, DateTime>>();
    series.add(charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff0000ff)),
        areaColorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff45b6fe)),
        id: identifier,
        data: readings,
        domainFn: (GaugeReading reading, _) => reading.timestamp,
        measureFn: (GaugeReading reading, _) => reading.dFlow));
    return series;
  }

  _getFlowReadings(json) {
    gaugeFlowReadings.clear();
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = double.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeFlowReadings.add(GaugeReading(value, timestamp));
    }
    setLocalVars(gaugeFlowReadings);
  }

  _getStageReadings(json) {
    gaugeStageReadings.clear();
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = double.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeStageReadings.add(GaugeReading(value, timestamp));
    }
    setLocalVars(gaugeStageReadings);
  }

  void setLocalVars(List<GaugeReading> readings) {
    try {
      DateTime updated = readings.last.timestamp;
      lastUpdate = DateFormat.yMMMMd().format(updated);
      timeOfLastUpdate = '${updated.hour}:${updated.minute}';
    } catch (e) {
      print("ERROR CAUGHT");
    }

  }
  bool containsFlowData() {
    return gaugeFlowReadings.length > 0;
  }

  bool containsStageData() {
    return gaugeStageReadings.length > 0;
  }

  Future<void> addFavorite(String faveId) async {
    await Storage.putFavorite(kFavoritesKey, faveId);
    this.isFavorite = await Storage.contains(kFavoritesKey, faveId);
    notifyListeners();
  }

  void removeFavorite(String faveId) async {
    favesVM.removeFavorite(faveId);
  }

  String getCurrentStats() {
    String currentFlow = '';
    String currentStage = '';
    if (gaugeFlowReadings.length > 0) {
      if (gaugeFlowReadings.last.dFlow > 99) {
        currentFlow = "${gaugeFlowReadings.last.dFlow.round()}cfs";
      } else {
        currentFlow = gaugeFlowReadings.last.dFlow > 0 ? "${gaugeFlowReadings.last.dFlow}cfs" : "N/A";
      }
    }
    if (gaugeStageReadings.length > 0) {
      currentStage = gaugeStageReadings.last.dFlow > 0.0 ? "${gaugeStageReadings.last.dFlow} ft" : "N/A";
    }
    if (currentStage.length > 0 && currentFlow.length > 0) {
      return "${currentStage} - ${currentFlow}";
    } else if (currentStage.length < 1 && currentFlow.length < 1) {
      return "This gauge is not currently reporting";
    }
    return currentFlow + currentStage;
  }


}
