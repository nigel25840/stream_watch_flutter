import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart';

import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/model/GaugeReadingModel.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:codable/codable.dart';

// let url = URL(string: "\(Constants.BASE_URL)&stateCd=\(state)&parameterCd=00060,00065&siteType=ST&siteStatus=all")!

// GAUGE NAME:          value.timeSeries[0].sourceInfo.siteName
// GAUGE  IDENTIFIER:   value.timeSeries[0].sourceInfo.siteCode[0].value

class DataProvider {

  Future<GaugeReadingModel> fetchGaugeDetail(String gaugeId, int hours) async {
    String url = 'https://waterservices.usgs.gov/nwis/iv/?site=${gaugeId}&format=json&period=PT${hours}H';
    Response res = await get(url);
    final readingJson = json.decode(res.body);
    final archive = KeyedArchive.unarchive(readingJson);
    GaugeReadingModel model = GaugeReadingModel();
    model.decode(archive);
    return model;
  }

  Future<Map<String, dynamic>> gaugeJson(String gaugeId, int hours) async {
    String url = 'https://waterservices.usgs.gov/nwis/iv/?site=${gaugeId}&format=json&period=PT${hours}H';
    Response res = await get(url);
    return jsonDecode(res.body);
  }

  Future<List<GaugeModel>> stateGauges(String stateAbbr) async {
    String url = '$kBaseUrl&stateCd=$stateAbbr&parameterCd=00060,00065&siteType=ST&siteStatus=all';
    Response res = await get(url);
    var json = jsonDecode(res.body);
    var gaugeList = List<GaugeModel>();
    var idSet = Set<String>();
    int count = json['value']['timeSeries'].length;

    for (int index = 0; index < count; index++) {
      var item = json['value']['timeSeries'][index]['sourceInfo'];
      var gID = item['siteCode'][0]['value'];
      var name = item['siteName'];
      if (!idSet.contains(gID)) {
        gaugeList.add(GaugeModel(gaugeName: name, gaugeState: stateAbbr, gaugeId: gID));
      }
      idSet.add(gID);
    }

    Comparator<GaugeModel> sortByname = (a,b) => a.gaugeName.compareTo(b.gaugeName);
    gaugeList.sort(sortByname);
    return gaugeList.toList();
  }

  // Single reading: https://waterservices.usgs.gov/nwis/iv/?site=03185400&format=json
  // &period=PT2H
  // value.timeSeries[0].values[0].value[0].value  (feet)
  // value.timeSeries[2].values[0].value[0].value  (cfs)
  // GaugeHeight/StreamFlow value.timeSeries[i].variable.variableName - "Streamflow, ft&#179;/s" or "Gage height, feet"
}
