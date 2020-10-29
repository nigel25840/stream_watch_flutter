import 'package:codable/codable.dart';

// populates a data model from a USGS nested json reading

class GaugeReadingModel extends Coding {
  GaugeDetailModel value;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    value = object.decodeObject('value', () => GaugeDetailModel());
  }

  @override
  void encode(KeyedArchive object) { }
}

class GaugeDetailModel extends Coding {
  List<GaugeTimeSeries> timeSeries;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    timeSeries = object.decodeObjects('timeSeries', () => GaugeTimeSeries());
  }

  @override
  void encode(KeyedArchive object) { }
}

class GaugeTimeSeries extends Coding {
  GaugeSourceInfo sourceInfo;
  GaugeVariable variable;
  List<GaugeValues> values;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    sourceInfo = object.decodeObject('sourceInfo', () => GaugeSourceInfo());
    variable = object.decodeObject('variable', () => GaugeVariable());
    values = object.decodeObjects('values', () => GaugeValues());
  }

  @override
  void encode(KeyedArchive object) { }

  List<double> getRawValues() {
    List<double> temp = [];
    if(values != null) {
      values.forEach((elem) {
        elem.value.forEach((reading) {
          temp.add(reading.value);
        });
      });
    }
    return temp;
  }
}

class GaugeSourceInfo extends Coding {
  String siteName;
  List<GaugeSiteCode> siteCode;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    siteName = object.decode('siteName');
    siteCode = object.decodeObjects('siteCode', () => GaugeSiteCode());
  }

  @override
  void encode(KeyedArchive object) { }
}

class GaugeSiteCode extends Coding {
  String value;
  String network;
  String agencyCode;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    value = object.decode('value');
    network = object.decode('network');
    agencyCode = object.decode('agencyCode');
  }

  @override
  void encode(KeyedArchive object) { }
}

class GaugeLocation extends Coding {
  GeoLocation geoLocation;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    geoLocation = object.decodeObject('geoLocation', () => GeoLocation());
  }

  @override
  void encode(KeyedArchive object) { }
}

class GeoLocation extends Coding {
  double latitude;
  double longitude;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    latitude = object.decode('latitude');
    longitude = object.decode('longitude');
  }

  @override
  void encode(KeyedArchive object) { }
}

class GaugeVariable extends Coding {
  String variableName;
  List<GaugeVariableCode> variableCode;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    variableName = object.decode('variableName');
    variableCode = object.decodeObjects('variableCode', () => GaugeVariableCode());
  }

  @override
  void encode(KeyedArchive object) { }
}

// GaugeValues contains a list of GaugeValue objects, which contain single readings
class GaugeValues extends Coding {
  List<GaugeValue> value;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    value = object.decodeObjects('value', () => GaugeValue());
  }

  @override
  void encode(KeyedArchive object) { }

  double currentReadingValue() {
    List<double> readings;
    if(value != null && value.length > 0) {
      return value.last.value;
    }
    return null;
  }
}

class GaugeValue extends Coding {
  double value;
  DateTime dateTime;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    value = double.parse(object.decode('value'));
    dateTime = object.decode('dateTime');
  }

  @override
  void encode(KeyedArchive object) { }
}

class GaugeVariableCode extends Coding {
  int variableId;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);
    variableId = object.decode('variableID');
  }
  @override
  void encode(KeyedArchive object) { }
}
