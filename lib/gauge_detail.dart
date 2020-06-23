import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:streamwatcher/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:streamwatcher/line_chart.dart';

import 'gauge_line_chart.dart';

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
  List<GaugeStageReading> gaugeStageReadings  = [];
  List<int>tickValues = [];
  var isCfs = true;

  int currentCfs = 0;
  int lowCfs = 0;
  int highCfs = 0;
  double currentStage = 0.0;
  double lowStage = 0.0;
  double highStage = 0.0;

  List<int> cfsTickVals = [];

  _getGaugeData() async {
    // 03185400
    http.Response res = await http.get('https://waterservices.usgs.gov/nwis/iv/?site=${widget.gaugeId}&format=json&period=PT48H');
    var json = jsonDecode(res.body);
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
    _generateChartSeries();
  }

  _generateChartSeries() {
    _seriesFlowData = List<charts.Series<GaugeFlowReading, DateTime>>();
    _seriesFlowData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff0000ff)),
        areaColorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff45b6fe)),
        id:'Readings',
        data: gaugeFlowReadings,
        domainFn: (GaugeFlowReading reading, _) => reading.timestamp,
        measureFn: (GaugeFlowReading reading, _) => reading.flow
      )
    );
  }

  _getFlowReadings(json) {
    tickValues = [];
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = int.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeFlowReadings.add(GaugeFlowReading(value, timestamp));
      tickValues.add(value);
    }
    currentCfs = tickValues.last;
    tickValues.sort();
    lowCfs = tickValues.first;
    highCfs = tickValues.last;

    tickValues = _setTickValues(highCfs, lowCfs, 5);
  }

  List<int> _setTickValues(int high, int low, int numberOfTicks) {
    double increase = 1.1;
    int _low = low;
    int _high = (high * 1.1).toInt();
    int total = _high - _low;
    int delta = (total / numberOfTicks).toInt();
    List<int> retval = [_low];
    for (int i = 1; i < numberOfTicks; i++) {
      _low += delta;
      retval.add(_low);
    }
    return retval;
  }

  _getStageReadings(json){
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = double.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeStageReadings.add(GaugeStageReading(value, timestamp));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGaugeData();
  }

  @override
  Widget build(BuildContext context) {
    _generateChartSeries();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gaugeName),
      ),
      body:
          Column(
            children: [
              Container (
                height: MediaQuery.of(context).size.height * .6,
                alignment: Alignment(0.0, 0.0),
                color: Colors.lightBlueAccent,
                child: charts.TimeSeriesChart(
                  _seriesFlowData,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.StaticNumericTickProviderSpec(
                    <charts.TickSpec<num>>[
                    charts.TickSpec<num>(tickValues[0]),
                    charts.TickSpec<num>(tickValues[1]),
                    charts.TickSpec<num>(tickValues[2]),
                    charts.TickSpec<num>(tickValues[3]),
                    charts.TickSpec<num>(tickValues[4])]
                    )
                  ),
                ),
              ),
              Container (
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment(-1.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("CONSTRAINED BOX"),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: MediaQuery.of(context).size.height * .25,
                          maxWidth: double.infinity,
                          maxHeight: MediaQuery.of(context).size.height * .25
                        ),
                      )
                    ],
                  ),
              ),
            ],
          )
      );

  }
}


class GaugeFlowReading {
  int flow;
  DateTime timestamp;
  GaugeFlowReading(this.flow, this.timestamp);
}

class GaugeStageReading {
  final double stage;
  final DateTime timestamp;
  GaugeStageReading(this.stage, this.timestamp);
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