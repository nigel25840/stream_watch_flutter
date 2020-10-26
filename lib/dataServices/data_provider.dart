import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart';

import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:codable/codable.dart';

// let url = URL(string: "\(Constants.BASE_URL)&stateCd=\(state)&parameterCd=00060,00065&siteType=ST&siteStatus=all")!

// GAUGE NAME:          value.timeSeries[0].sourceInfo.siteName
// GAUGE  IDENTIFIER:   value.timeSeries[0].sourceInfo.siteCode[0].value

class DataProvider {


  Future<GaugeReadingModel> fetchGaugeDetail(String gaugeId, {int hours = 72}) async {
    String url = 'https://waterservices.usgs.gov/nwis/iv/?site=${gaugeId}&format=json&period=PT${hours}H';
    Response res = await get(url);
    final readingJson = json.decode(res.body);
    final archive = KeyedArchive.unarchive(readingJson);
    GaugeReadingModel model = GaugeReadingModel();
    model.decode(archive);
    return model;
  }

  // Future<Map<String, dynamic>> gaugeJson(String gaugeId, int hours) async {
  //   String url = 'https://waterservices.usgs.gov/nwis/iv/?site=${gaugeId}&format=json&period=PT${hours}H';
  //   Response res = await get(url);
  //   return jsonDecode(res.body);
  // }

  Future<List<GaugeReferenceModel>> stateGauges(String stateAbbr) async {

    var gaugeList = List<GaugeReferenceModel>();
    String url = '$kBaseUrl&stateCd=$stateAbbr&parameterCd=00060,00065&siteType=ST&siteStatus=all';
    Response res = await get(url);
    final refJson = json.decode(res.body);
    final archive = KeyedArchive.unarchive(refJson);
    GaugeRefModel model = GaugeRefModel();
    model.decode(archive);
    int count = model.value.timeSeries.length;
    for (int index = 0; index < count; index ++){
      GaugeReference ref = model.value.timeSeries[index].sourceInfo;
      gaugeList.add(GaugeReferenceModel(gaugeName: ref.siteName, gaugeId: ref.siteCode.first.value));
    }

    final ids = gaugeList.map((e) => e.gaugeId).toSet();
    gaugeList.retainWhere((element) => ids.remove(element.gaugeId));

    Comparator<GaugeReferenceModel> sortByname = (a,b) => a.gaugeName.compareTo(b.gaugeName);
    gaugeList.sort(sortByname);
    return gaugeList;
  }
}
