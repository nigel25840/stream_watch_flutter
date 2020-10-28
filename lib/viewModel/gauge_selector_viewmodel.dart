import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class GaugeSelectorViewModel extends ChangeNotifier {
  List<GaugeReferenceModel> stateList;
  String stateAbbreviation;

  GaugeSelectorViewModel(this.stateAbbreviation);

  Future<GaugeRefModel> poplulate() async {
    String url = '$kBaseUrl&stateCd=$stateAbbreviation&parameterCd=00060,00065&siteType=ST&siteStatus=all';
    return await DataProvider().fetchFromUrl<GaugeRefModel>(url, GaugeRefModel());
  }
}