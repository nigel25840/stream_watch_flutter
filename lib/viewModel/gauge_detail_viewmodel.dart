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

  // the GaugeReferenceModel contains the id used in the network request
  // to fetch details for the gauge. Also contains the gauge name, also used
  // to compare whether this view model should be refreshed
  GaugeReferenceModel referenceModel;

  GaugeReadingModel model;
  GaugeDetailViewModel();

  List<charts.Series<GaugeValue, DateTime>> seriesFlowData;
  List<charts.Series<GaugeValue, DateTime>> seriesStageData;

  List<GaugeValue> lineSeriesFlow;
  List<GaugeValue> lineSeriesStage;

  double highStage;
  double lowStage;
  int highFlow;
  int lowFlow;

  var reloading = true;
  bool isCfs = false; // all gauges report stage, not all report cfs

  // a full dataset is one that contains both stage and flow
  // some gauge reports only stage readings
  bool containsFullDataset = false;

  void setReferenceModel(GaugeReferenceModel mdl) {
    referenceModel = mdl;
    setReadings();
    _populate();
  }

  Future<GaugeDetailViewModel> _populate() async {
    isCfs = false; // ensure this is initialized at load

    // if there is a model from a previous load, ensure that it has changed before reloading
    if (model != null) {
      String persistedGaugeId =
          model.value.timeSeries.first.sourceInfo.siteCode.last.value;
      reloading = referenceModel.gaugeId != persistedGaugeId;
    }

    await DataProvider().fetchGaugeDetail(referenceModel.gaugeId).then((model) {
      this.model = model;
      setReadings();
      reloading = false;
      notifyListeners();
    });
  }

  String getGaugeName() {
    if (model == null) {
      return 'Loading...';
    }
    String retVal = model.value.timeSeries[0].sourceInfo.siteName;
    return (retVal != null) ? retVal : 'Loading...';
  }

  // traverses through the gauge detail model - initializes data for the viewModel
  void setReadings() {
    if (model == null) return;

    // once populated, these are used to obtain high/low readings
    List<double> sortedFlows = [];
    List<double> sortedStages = [];

    // TimeSeries main data set returned by USGS
    // GaugeReadingModel mimics its structure
    List<GaugeTimeSeries> series = model.value.timeSeries;
    series.forEach((ts) {
      if (ts.variable.variableName.toLowerCase().contains('streamflow')) {
        lineSeriesFlow = ts.values.first.value;
        sortedFlows = _getUltimates(ts.values.first.value);
      } else if (ts.variable.variableName.toLowerCase().contains('gage')) {
        lineSeriesStage = ts.values.first.value;
        sortedStages = _getUltimates(ts.values.first.value);
      }
    });

    containsFullDataset = (lineSeriesFlow.length > 0 && lineSeriesStage.length > 0);

    if (sortedFlows != null && sortedFlows.length > 0) {
      lowFlow = sortedFlows.first.toInt();
      highFlow = sortedFlows.last.toInt();
    }
    if (sortedStages != null && sortedStages.length > 0) {
      lowStage = sortedStages.first;
      highStage = sortedStages.last;
    }
  }

  // sets the reading type, either stage or flow
  void setReadingType(int state) {
    isCfs = (state < 1);
    notifyListeners();
  }

  // 'ulimates' are high and low values for flow and stage
  List<double> _getUltimates(List<GaugeValue> valueObjects) {
    if (valueObjects.length < 1) {
      return [];
    }

    List<double> retArray = [];
    valueObjects.forEach((val) {
      retArray.add(val.value);
    });
    retArray.sort((a, b) => a.compareTo(b));
    return [retArray.first, retArray.last];
  }

  // creates a line series used by the chart view
  List<ChartSeries<GaugeValue, String>> makeSeries(List<GaugeValue> vals) {
    List<ChartSeries<GaugeValue, String>> retVal = [];
    retVal.add(LineSeries(
        dataSource: vals,
        xValueMapper: (GaugeValue reading, _) =>
            DateFormat.Md().format(reading.dateTime).toString(), //Md
        yValueMapper: (GaugeValue reading, _) => reading.value));

    return retVal;
  }
}
