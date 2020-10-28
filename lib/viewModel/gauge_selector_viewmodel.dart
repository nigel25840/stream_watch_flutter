import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class GaugeSelectorViewModel extends ChangeNotifier {
  List<GaugeReferenceModel> stateList;
  List<GaugeReferenceModel> gaugeModels = [];

  GaugeSelectorViewModel();

  Future<List<GaugeReferenceModel>> poplulateVM({String state}) async {
    gaugeModels.clear();
    String url = '$kBaseUrl&stateCd=$state&parameterCd=00060,00065&siteType=ST&siteStatus=all';
    await DataProvider().fetchFromUrl<GaugeRefModel>(url, GaugeRefModel()).then((model) {
      model.value.timeSeries.forEach((ts) { 
        GaugeReference ref = ts.sourceInfo;
        gaugeModels.add(GaugeReferenceModel(gaugeName: ref.siteName, gaugeId: ref.gaugeId));
      });

      final ids = gaugeModels.map((e) => e.gaugeId).toSet();
      gaugeModels.retainWhere((element) => ids.remove(element.gaugeId));
      Comparator<GaugeReferenceModel> sortByName = (a, b) => a.gaugeName.compareTo(b.gaugeName);
      gaugeModels.sort(sortByName);
    });
    return gaugeModels;
  }
}