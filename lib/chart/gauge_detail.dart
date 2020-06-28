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

  ChartManager manager = ChartManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isCfs = manager.isCfs;
    return Scaffold(
        appBar: AppBar(
          title: Text("STREAM WATCH"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
//                  _generateChartFlowSeries();
                print('REFRESH TAPPED');
                });
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: manager.getGaugeData(widget.gaugeId),
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
                              '${manager.gaugeFlowReadings.last.flow}cfs - ${manager.gaugeStageReadings.last.stage}ft',
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
                            isCfs ? manager.seriesFlowData : manager.seriesStageData,
                            animate: true,
                            animationDuration: Duration(milliseconds: 700),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                                tickProviderSpec:
                                    charts.StaticNumericTickProviderSpec(<
                                        charts.TickSpec<num>>[
                              charts.TickSpec<num>(isCfs
                                  ? manager.flowTickValues[0]
                                  : manager.stageTickValues[0]),
                              charts.TickSpec<num>(isCfs
                                  ? manager.flowTickValues[1]
                                  : manager.stageTickValues[1]),
                              charts.TickSpec<num>(isCfs
                                  ? manager.flowTickValues[2]
                                  : manager.stageTickValues[2]),
                              charts.TickSpec<num>(isCfs
                                  ? manager.flowTickValues[3]
                                  : manager.stageTickValues[3]),
                              charts.TickSpec<num>(isCfs
                                  ? manager.flowTickValues[4]
                                  : manager.stageTickValues[4])
                            ]))))
                  ],
                );
              } else {
                return Align(child: CircularProgressIndicator());
              }
            }));
  }
}
