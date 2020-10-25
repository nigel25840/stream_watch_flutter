import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

class GaugeDetailViewModel extends ChangeNotifier {
  GaugeReferenceModel referenceModel;
  String gaugeId;
  int period;
  GaugeReadingModel model;
  GaugeDetailViewModel();

  List<charts.Series<GaugeValue, DateTime>> seriesFlowData;
  List<charts.Series<GaugeValue, DateTime>> seriesStageData;

  List<GaugeValue> lineSeriesFlow;
  List<GaugeValue> lineSeriesStage;

  List<ChartSeries<GaugeValue, String>> stageSeries;
  List<ChartSeries<GaugeValue, String>> flowSeries;

  double highStage;
  double lowStage;
  int highFlow;
  int lowFlow;

  var reloading = true;

  void setReferenceModel(GaugeReferenceModel mdl) {
    referenceModel = mdl;
    setReadings();
    _populate();
  }

  Future<GaugeDetailViewModel> _populate() async {
    var reload = true;

    // if there is a model from a previous load, ensure that it has changed before reloading
    if (model != null) {
      String persistedGaugeId =
          model.value.timeSeries.first.sourceInfo.siteCode.last.value;
      reloading = referenceModel.gaugeId != persistedGaugeId;
    }

    if (reload) {
      await DataProvider()
          .fetchGaugeDetail(referenceModel.gaugeId)
          .then((model) {
        this.model = model;
        setReadings();
        reloading = false;
        notifyListeners();
      });
    }
  }

  String getGaugeName() {
    if (model == null) {
      return 'Loading...';
    }
    String retVal = model.value.timeSeries[0].sourceInfo.siteName;
    return (retVal != null) ? retVal : 'Loading...';
  }

  void setReadings() {
    if (model == null) return;

    List<double> sortedFlows = [];
    List<double> sortedStages = [];

    List<GaugeTimeSeries> series = model.value.timeSeries;
    series.forEach((ts) {
      if (ts.variable.variableName.toLowerCase().contains('streamflow')) {
        lineSeriesFlow = ts.values.first.value;
        flowSeries = makeSeries(ts.values.first.value);
        sortedFlows = _getUltimates(ts.values.first.value);
      } else if (ts.variable.variableName.toLowerCase().contains('gage')) {
        stageSeries = makeSeries(ts.values.first.value);
        sortedStages = _getUltimates(ts.values.first.value);
      }
    });

    lowFlow = sortedFlows.first.toInt();
    highFlow = sortedFlows.last.toInt();
    lowStage = sortedStages.first;
    highStage = sortedStages.last;
  }

  List<double> _getUltimates(List<GaugeValue> valueObjects) {
    List<double> retArray = [];
    valueObjects.forEach((val) {
      retArray.add(val.value);
    });
    retArray.sort((a, b) => a.compareTo(b));
    return [retArray.first, retArray.last];
  }

  List<ChartSeries<GaugeValue, String>> makeSeries(List<GaugeValue> vals) {
    // final df = DateFormat('MM/d');

    List<ChartSeries<GaugeValue, String>> retVal = [];
    retVal.add(LineSeries(
        dataSource: vals,
        xValueMapper: (GaugeValue reading, _) =>
            DateFormat.Md().format(reading.dateTime).toString(), //Md
        yValueMapper: (GaugeValue reading, _) => reading.value));

    return retVal;
  }

  String lastupdate() {
    return DateTime.now().toString();
  }
}
