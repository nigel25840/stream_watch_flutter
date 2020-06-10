
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GaugeLineChart extends StatefulWidget {
  @override
  _GaugeLineChart createState() => _GaugeLineChart();



}

class _GaugeLineChart extends State<GaugeLineChart> {
  Widget build(BuildContext context) {

    final fromDate = DateTime.now().subtract(Duration(hours: 24));
    final toDate = DateTime.now();

    DateTime date1 = DateTime.now().subtract(Duration(hours: 2));
    DateTime date2 = DateTime.now().subtract(Duration(hours: 3));

    List<DataPoint> getReadings() {
      var retval = List<DataPoint>();
      for (int index = 0; index < 24; index++) {
        double val = (index % 2 == 0)
            ? index.roundToDouble() - 10.0 : index.roundToDouble() + 12.0;
        retval.add(DataPoint<DateTime>(
            value: val,
            xAxis: DateTime.now()
                .subtract(Duration(seconds: 3600 + (index * 2000)))));
      }
      return retval;
    }

    return   Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: BezierChart(
        fromDate: fromDate,
        bezierChartScale: BezierChartScale.HOURLY,
        xAxisCustomValues: [1,2,3,4,5],
        toDate: toDate,
        selectedDate: toDate,
        series: [
          BezierLine(
            label: " Reading",
            data: getReadings(),
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 2.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: false,
          showDataPoints: true,
          verticalIndicatorFixedPosition: false,
          backgroundColor: Colors.lightBlue,
          footerHeight: 30.0,
        ),
      ),
    );
  }
}