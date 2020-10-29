// import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';

// tests both types of API calls using a mock service
// ensures code is returning proper object models

void main() {
  group('DataProvider returns correct model objects', () {

    test('View model can produce a valid GaugeRefModel for a state (WV)', () async {
      // mimic the following url
      // https://waterservices.usgs.gov/nwis/iv/?format=json&stateCd=WV&parameterCd=00060,00065&siteType=ST&siteStatus=all
      String url = 'http://localhost:3001/getWVGauges'; // Mockoon API
      GaugeRefModel m = await DataProvider().fetchFromUrl(url, GaugeRefModel());
      expect((m == null), false);
      expect((m.value.timeSeries.length > 0), true);
    });

    test('View model produces a valid GaugeReadingModel for a particular gauge ID', () async {

      // mimic the following url
      // https://waterservices.usgs.gov/nwis/iv/?format=json&site=03185400&period=PT72H
      String url = 'http://localhost:3001/getRiver'; // Mockoon API
      GaugeReadingModel rm = await DataProvider().fetchFromUrl(url, GaugeReadingModel());
      expect((rm == null), false);
      expect((rm.value.timeSeries.length > 0), true);

      expect((rm.value.timeSeries.first == null), false);
      GaugeTimeSeries ts = rm.value.timeSeries.first;
      GaugeSourceInfo info = ts.sourceInfo;

      expect((info == null), false);
      expect((info.siteName == null), false);
      expect((info.siteCode == null), false);
    });

  });
}
