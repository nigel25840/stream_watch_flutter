import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:streamwatcher/constants.dart';
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

  _getGaugeData() async {
    // 03185400
    http.Response res = await http.get('https://waterservices.usgs.gov/nwis/iv/?site=${widget.gaugeId}&format=json&period=PT48H');
    var json = jsonDecode(res.body);
    int count = json['value']['timeSeries'].length;
    var timeseries = json['value']['timeSeries'];

    for (int index = 0; index < count; index++) {
      String item = timeseries[index]['variable']['variableName'];
      if (item.contains('Streamflow')) {
        print(timeseries[index]['values'][0]['value']);
      } else if (item.contains('Gage height')) {
        print(timeseries[index]['values'][0]['value']);
      }
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
