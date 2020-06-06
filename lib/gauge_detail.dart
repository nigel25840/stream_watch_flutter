import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/constants.dart';
import 'dart:core';

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

  @override
  Widget build(BuildContext context) {
    final fromDate = DateTime.now().subtract(Duration(hours: 10));
    final toDate = DateTime.now();

    DateTime date1 = DateTime.now().subtract(Duration(hours: 2));
    DateTime date2 = DateTime.now().subtract(Duration(hours: 3));

    List<DataPoint> getReadings() {
      var retval = List<DataPoint>();
      for (int index = 0; index < 10; index++) {
        double val = (index % 2 == 0) ? index.roundToDouble() + 10.0 :  index.roundToDouble() - 12.0;
        retval.add(DataPoint<DateTime>(value: val, xAxis: DateTime.now().subtract(Duration(hours: 2 + index))));
      }
      return retval;
    }

    return Center(
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.HOURLY,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "Duty",
              data: getReadings(),
            ),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundColor: Colors.lightBlue,
            footerHeight: 30.0,

          ),
        ),
      ),
    );

  }
}
