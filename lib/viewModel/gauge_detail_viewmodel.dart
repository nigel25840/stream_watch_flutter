
import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class GaugeDetailViewModel extends ChangeNotifier {

  GaugeReferenceModel referenceModel;
  String gaugeId;
  int period;
  GaugeReadingModel model;



  GaugeDetailViewModel();

  void setReferenceModel(GaugeReferenceModel mdl) {
    referenceModel = mdl;
    _populate();
  }

  Future<GaugeDetailViewModel> _populate() async {
    await DataProvider().fetchGaugeDetail(referenceModel.gaugeId).then((model) {
      this.model = model;
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

  // fetches period high or low for cfs or stage
  double getUltimateValue(bool cfs, bool highValue) {
    if (model == null) {
      return -99;
    }
    List<GaugeTimeSeries> series = model.value.timeSeries;
    series.forEach((ts) {
      var readingType = '';
      if (ts.variable.variableName.toLowerCase().contains('streamflow') || ts.variable.variableName.toLowerCase().contains('gage')) {
        readingType = ts.variable.variableName;
        ts.values.forEach((val) {
          val.value.forEach((gaugeVal) {
            print('$readingType - ${gaugeVal.value}');
          });
        });
      }
    });
  }

  String lastupdate() {
    return DateTime.now().toString();
  }


}