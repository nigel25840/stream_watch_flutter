import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:streamwatcher/chart/chart_manager.dart';
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
  ChartManager mgr = ChartManager();

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
                  mgr.isCfs = !mgr.isCfs;
                });
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: mgr.getGaugeData(widget.gaugeId),
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
                              '${mgr.gaugeFlowReadings.last.flow}cfs - ${mgr.gaugeStageReadings.last.stage}ft',
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
                            mgr.isCfs
                                ? mgr.seriesFlowData
                                : mgr.seriesStageData,
                            animate: true,
                            animationDuration: Duration(milliseconds: 700),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                                tickProviderSpec:
                                    charts.StaticNumericTickProviderSpec(<
                                        charts.TickSpec<num>>[
                              charts.TickSpec<num>(mgr.isCfs
                                  ? mgr.flowTickValues[0]
                                  : mgr.stageTickValues[0]),
                              charts.TickSpec<num>(mgr.isCfs
                                  ? mgr.flowTickValues[1]
                                  : mgr.stageTickValues[1]),
                              charts.TickSpec<num>(mgr.isCfs
                                  ? mgr.flowTickValues[2]
                                  : mgr.stageTickValues[2]),
                              charts.TickSpec<num>(mgr.isCfs
                                  ? mgr.flowTickValues[3]
                                  : mgr.stageTickValues[3]),
                              charts.TickSpec<num>(mgr.isCfs
                                  ? mgr.flowTickValues[4]
                                  : mgr.stageTickValues[4])
                            ]))
                        ))
                  ],
                );
              } else {
                return Align(child: CircularProgressIndicator());
              }
            }));
  }
}
