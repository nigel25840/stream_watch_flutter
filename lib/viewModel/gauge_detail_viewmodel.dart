
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class GaugeDetailViewModel extends ChangeNotifier {

  GaugeReferenceModel referenceModel;
  String gaugeId;
  int period;
  GaugeReadingModel model;
  GaugeDetailViewModel();

  List<double> stageReadings = [];
  List<double> cfsReadings = [];

  void setReferenceModel(GaugeReferenceModel mdl) {
    referenceModel = mdl;
    setReadings();
    _populate();
  }

  Future<GaugeDetailViewModel> _populate() async {
    await DataProvider().fetchGaugeDetail(referenceModel.gaugeId).then((model) {
      this.model = model;
      setReadings();
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

  void setReadings() {
    if (model == null) return;

    List<GaugeTimeSeries> series = model.value.timeSeries;
    series.forEach((ts) {
      if (ts.variable.variableName.toLowerCase().contains('streamflow')) {
        cfsReadings.clear();
        _makeValueList(true, ts.values[0].value);
      } else if (ts.variable.variableName.toLowerCase().contains('gage')) {
        stageReadings.clear();
        _makeValueList(false, ts.values[0].value);
      }
    });
  }
  
  void _makeValueList(bool cfs, List<GaugeValue> values) {

    for (GaugeValue val in values) {
      double reading = double.parse(val.value);
      cfs ? cfsReadings.add(reading) : stageReadings.add(reading);
    }
  }

  // fetches period high or low for cfs or stage
  String getUltimateValue({bool cfs, bool highValue}) {
    if (model == null) {
      return 'N\\A';
    }
    double retVal;
    if (cfs) {
      List<double> temp = []..addAll(cfsReadings);
      temp.sort((a,b) => a.compareTo(b));
      retVal = highValue ? temp.last : temp.first;
    } else {
      List<double> temp = []..addAll(stageReadings);
      temp.sort((a, b) => a.compareTo(b));
      retVal = highValue ? temp.last : temp.first;
    }
    return (retVal != null) ? retVal.toString() : 'N\\A';
  }

  String lastupdate() {
    return DateTime.now().toString();
  }


}