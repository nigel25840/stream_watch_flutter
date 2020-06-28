import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'dart:convert';
import 'package:streamwatcher/model/flow_reading_model.dart';
import 'package:streamwatcher/model/stage_reading_model.dart';

class GaugeDetail extends StatefulWidget {
  final String gaugeId;
  final String gaugeName;
  GaugeDetail({this.gaugeId, this.gaugeName});
  _GaugeDetail createState() => _GaugeDetail();
}

class _GaugeDetail extends State<GaugeDetail> {
  String getGauge() {
    return widget.gaugeId;
  }

  List<charts.Series<GaugeFlowReading, DateTime>> _seriesFlowData;
  List<charts.Series<GaugeStageReading, DateTime>> _seriesStageData;

  List<GaugeFlowReading> gaugeFlowReadings = [];
  List<GaugeStageReading> gaugeStageReadings = [];
  List<int> flowTickValues = [];
  List<double> stageTickValues = [];
  String lastUpdate = '';
  String timeOfLastUpdate = '';

  int currentCfs = 0;
  int lowCfs = 0;
  int highCfs = 0;
  double currentStage = 0.0;
  double lowStage = 0.0;
  double highStage = 0.0;
  int hours = 72;
  int tickCount = 5;
  var isCfs = false;

  List<int> cfsTickVals = [];

  _getGaugeData() async {
    var json = await DataProvider().gaugeJson(widget.gaugeId);
    int count = json['value']['timeSeries'].length;
    var timeseries = json['value']['timeSeries'];

    for (int index = 0; index < count; index++) {
      String item = timeseries[index]['variable']['variableName'];
      if (item.contains('Streamflow')) {
        _getFlowReadings(timeseries[index]['values'][0]['value']);
      } else if (item.contains('Gage height')) {
        _getStageReadings(timeseries[index]['values'][0]['value']);
      }
    }
    await _generateChartFlowSeries();
    await _generateChartStageSeries();
  }

  _generateChartFlowSeries() {
    print("GENERATING CHART FLOW SERIES");
    _seriesFlowData = List<charts.Series<GaugeFlowReading, DateTime>>();
    _seriesFlowData.add(charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff0000ff)),
        areaColorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff45b6fe)),
        id: 'FlowReadings',
        data: gaugeFlowReadings,
        domainFn: (GaugeFlowReading reading, _) => reading.timestamp,
        measureFn: (GaugeFlowReading reading, _) => reading.flow));
  }

  _generateChartStageSeries() {
    print("GENERATING CHART STAGE SERIES");
    _seriesStageData = List<charts.Series<GaugeStageReading, DateTime>>();
    _seriesStageData.add(charts.Series(
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
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = int.parse(dict['value']);
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
    flowTickValues = _setFlowTickValues(highCfs, lowCfs, tickCount);
  }

  _getStageReadings(json) {
    stageTickValues = [];
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
    stageTickValues = _setStageTickValues(highStage, lowStage, tickCount);
  }

  List<int> _setFlowTickValues(int high, int low, int numberOfTicks) {
    double increase = 1.1;
    int _low = low;
    int _high = (high * increase).toInt();
    int total = _high - _low;
    int delta = (total / numberOfTicks).toInt();
    List<int> retval = [_low];
    for (int i = 1; i < numberOfTicks; i++) {
      _low += delta;
      retval.add(_low);
    }
    return retval;
  }

  List<double> _setStageTickValues(double high, double low, int numberOfTicks) {
    double increase = 1.1;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _getGaugeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("STREAM WATCH"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _generateChartFlowSeries();
                });
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: _getGaugeData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.gaugeName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${gaugeFlowReadings.last.flow}cfs - ${gaugeStageReadings.last.stage}ft',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                        ),
                      ],
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * .5,
                        alignment: Alignment(0.0, 0.0),
                        color: Colors.lightBlueAccent,
                        child: charts.TimeSeriesChart(
                            isCfs ? _seriesFlowData : _seriesStageData,
                            animate: true,
                            animationDuration: Duration(milliseconds: 700),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                                tickProviderSpec:
                                    charts.StaticNumericTickProviderSpec(<
                                        charts.TickSpec<num>>[
                              charts.TickSpec<num>(isCfs
                                  ? flowTickValues[0]
                                  : stageTickValues[0]),
                              charts.TickSpec<num>(isCfs
                                  ? flowTickValues[1]
                                  : stageTickValues[1]),
                              charts.TickSpec<num>(isCfs
                                  ? flowTickValues[2]
                                  : stageTickValues[2]),
                              charts.TickSpec<num>(isCfs
                                  ? flowTickValues[3]
                                  : stageTickValues[3]),
                              charts.TickSpec<num>(isCfs
                                  ? flowTickValues[4]
                                  : stageTickValues[4])
                            ]))))
                  ],
                );
              } else {
                return Align(child: CircularProgressIndicator());
              }
            }));
  }
}





//charts.LineChart(
//_seriesFlowData,
//primaryMeasureAxis: charts.NumericAxisSpec(
//tickProviderSpec: charts.StaticNumericTickProviderSpec(
//<charts.TickSpec<num>>[
//charts.TickSpec<num>(tickValues[0]),
//charts.TickSpec<num>(tickValues[1]),
//charts.TickSpec<num>(tickValues[2]),
//charts.TickSpec<num>(tickValues[3]),
//charts.TickSpec<num>(tickValues[4]),
//]
//)
//),
//)
