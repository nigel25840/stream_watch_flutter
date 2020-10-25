// represents a gauge item as downloaded from a selected state

import 'package:codable/codable.dart';

class GaugeReferenceModel {
  final String gaugeName;
  final String gaugeState;
  final String gaugeId;

  double lastFlowReading;
  double lastStageReading;
  DateTime lastUpdated;

  GaugeReferenceModel({this.gaugeName, this.gaugeState, this.gaugeId});
}

class GaugeRefModel extends Coding {

  GaugeRefValue value;

  @override
  void decode(KeyedArchive object) {
    value = object.decodeObject('value', () => GaugeRefValue());
  }
  @override void encode(KeyedArchive object) {}
}

class GaugeRefValue extends Coding {

  List<GaugeRefTimeSeries> timeSeries;
  
  @override
  void decode(KeyedArchive object) {
    timeSeries = object.decodeObjects('timeSeries', () => GaugeRefTimeSeries());
  }
  @override void encode(KeyedArchive object) {}
}

class GaugeRefTimeSeries extends Coding {

  GaugeReference sourceInfo;

  @override
  void decode(KeyedArchive object) {
    sourceInfo = object.decodeObject('sourceInfo', () => GaugeReference());
  }

  @override void encode(KeyedArchive object) {}
}

class GaugeReference extends Coding {

  String siteName;
  String gaugeId;
  List<GaugeRefSiteCode> siteCode;

  @override
  void decode(KeyedArchive object) {
    siteName = object.decode('siteName');
    siteCode = object.decodeObjects('siteCode', () => GaugeRefSiteCode());
    gaugeId = siteCode.first.value;
  }

  @override void encode(KeyedArchive object) {}
}

class GaugeRefSiteCode extends Coding {

  String value;

  @override
  void decode(KeyedArchive object) {
    value = object.decode('value');
  }

  @override void encode(KeyedArchive object) {}
}
