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

  Future<T> fetchFromUrl<T extends Coding>(String url, T model) async {
    Response res = await get(url);
    final readingJson = json.decode(res.body);
    final archive = KeyedArchive.unarchive(readingJson);
    model.decode(archive);
    return model;
  }
}
