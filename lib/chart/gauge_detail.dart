import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:core';
import 'package:streamwatcher/chart/chart_manager.dart';

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
                          child: Text(mgr.getCurrentStats(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)
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
                                    charts.StaticNumericTickProviderSpec(mgr.getTicks(5, mgr.isCfs)))
                        ))
                  ],
                );
              } else {
                return Align(child: CircularProgressIndicator());
              }
            }));
  }
}
