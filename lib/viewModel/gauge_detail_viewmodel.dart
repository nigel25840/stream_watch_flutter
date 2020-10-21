
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

  // fetches period high or low for cfs or stage
  double getUltimateValue(bool cfs, bool highValue) {

  }

  String lastupdate() {
    return DateTime.now().toString();
  }


}