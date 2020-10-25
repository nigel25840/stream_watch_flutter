import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/gauge_detail_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {

  GaugeReferenceModel refModel;
  GaugeDetailViewModel viewModel;

  ChartView({this.refModel, this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: refModel.gaugeName)  ,
        primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
          dateFormat: DateFormat.Hm(),
          interval: 5,
        ),
        series: <SplineSeries<GaugeValue, DateTime>>[
          SplineSeries<GaugeValue, DateTime>(
            dataSource: viewModel.lineSeriesFlow,
            xValueMapper: (GaugeValue reading, _) => reading.dateTime,
            yValueMapper: (GaugeValue reading, _) => reading.value,
          )
        ]);
  }
}
