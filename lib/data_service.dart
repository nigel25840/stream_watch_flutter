import 'dart:core';
import 'package:http/http.dart';

import 'package:streamwatcher/constants.dart';

// let url = URL(string: "\(Constants.BASE_URL)&stateCd=\(state)&parameterCd=00060,00065&siteType=ST&siteStatus=all")!

class DataService {

  Future<Map<String, dynamic>> stateGauges(String stateAbbr) async {

    String url = '$kBaseUrl&stateCd=$stateAbbr&parameterCd=00060,00065&siteType=ST&siteStatus=all';
    Response res = await get(url);

    print(res.body);

    return null;
  }

}