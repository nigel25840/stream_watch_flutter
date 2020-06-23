import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  List<charts.Series<GaugeFlowReading, double>> _seriesLineData;
  List<GaugeFlowReading> gaugeFlowReadings = [];
  List<GaugeStageReading> gaugeStageReadings  = [];

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
  }

  List<GaugeFlowReading> _getFlowReadings(json) {
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = int.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeFlowReadings.add(GaugeFlowReading(value, i.toDouble()));
      print("OBJECT: ${value} - ${timestamp}");
    }
  }

  List<GaugeStageReading> _getStageReadings(json){
    for (int i = 0; i < json.length; i++) {
      var dict = json[i];
      var value = double.parse(dict['value']);
      var timestamp = DateTime.parse(dict['dateTime']);
      gaugeStageReadings.add(GaugeStageReading(value, timestamp));
      print("OBJECT: ${value} - ${timestamp}");
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
                color: Colors.orange,
                child: Text(widget.gaugeId),
              ),
              Container (
                width: double.infinity,
                color: Colors.white,
                alignment: Alignment(0.0, -1.0),
                  child: Column(
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
  double timestamp;
  GaugeFlowReading(this.flow, this.timestamp);
}

class GaugeStageReading {
  final double stage;
  final DateTime timestamp;
  GaugeStageReading(this.stage, this.timestamp);
}
