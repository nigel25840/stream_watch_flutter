//
////import 'package:bezier_chart/bezier_chart.dart';
////import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
////import 'package:charts_common/common.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
//class GaugeLineChart extends StatefulWidget {
//
//  @override
//  _GaugeLineChartState createState() => _GaugeLineChartState();
//}
//
//class _GaugeLineChartState extends State<GaugeLineChart> {
//
//  List<charts.Series<GaugeFlowReading, double>> _flowSeries;
//
//  _getReadingData() {
//    List<GaugeFlowReading> flows = [];
//    for(int i = 0; i < 100; i++) {
////      flows.add(GaugeFlowReading(i * 1000, DateTime.now().subtract(Duration(hours: i)), Color(0xffb74093)));
//    }
//
//    _flowSeries.add(
//      charts.Series(
//        data: flows,
//        domainFn: (GaugeFlowReading reading, _) => reading.timestamp,
//        measureFn: (GaugeFlowReading reading, _) => reading.flow,
//        id: 'flows',
//        labelAccessorFn: (GaugeFlowReading row,_) => '${row.timestamp.toString()}'
//      )
//    );
//
//    @override
//    void initState() {
//      super.initState();
//      _flowSeries = List<charts.Series<GaugeFlowReading, double>>();
//      _getReadingData();
//    }
//
//  }
//
//
//
//  Widget build(BuildContext context) {
//    return Center(
//        child: charts.LineChart(
//          _flowSeries,
//          defaultRenderer: charts.LineRendererConfig(
//            includeArea: true, stacked: true),
//          animate: true,
//          animationDuration: Duration(seconds: 5),
//          behaviors: [
//            charts.ChartTitle('Years',
//                behaviorPosition: charts.BehaviorPosition.bottom,
//                titleOutsideJustification:charts.OutsideJustification.middleDrawArea)
//          ],
//          ),
//        );
//  }
//}
//
//
//
//
//
