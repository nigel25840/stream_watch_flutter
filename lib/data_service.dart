import 'dart:convert';
import 'dart:core';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

import 'package:streamwatcher/constants.dart';
import 'package:streamwatcher/gauge_model.dart';

// let url = URL(string: "\(Constants.BASE_URL)&stateCd=\(state)&parameterCd=00060,00065&siteType=ST&siteStatus=all")!

// GAUGE NAME:          value.timeSeries[0].sourceInfo.siteName
// GAUGE  IDENTIFIER:   value.timeSeries[0].sourceInfo.siteCode[0].value

class DataService {
  Future<List<GaugeModel>> stateGauges(String stateAbbr) async {
    String url =
        '$kBaseUrl&stateCd=$stateAbbr&parameterCd=00060,00065&siteType=ST&siteStatus=all';
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
}
