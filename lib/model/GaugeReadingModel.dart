
import 'package:dart_codable/dart_codable.dart';

class GaugeReadingModel extends Codable {
  GaugeReadingModel.decode(Map<String, dynamic> data): super.decode(data);
  GaugeDetailModel value;
}

class GaugeDetailModel extends Decodable {
  GaugeDetailModel.decode(Map<String, dynamic> data): super.decode(data);
  List<GaugeTimeSeries> timeSeries;
}

class GaugeTimeSeries extends Decodable {
  GaugeTimeSeries.decode(Map<String, dynamic> data): super.decode(data);
  GaugeSourceInfo sourceInfo;
  GaugeVariable variable;
  List<GaugeValues> values;
}

class GaugeSourceInfo extends Decodable {
  GaugeSourceInfo.decode(Map<String, dynamic> data): super.decode(data);
  String siteName;
  List<GaugeSiteCode> siteCode;
}

class GaugeSiteCode extends Decodable {
  GaugeSiteCode.decode(Map<String, dynamic> data): super.decode(data);
  String value;
  String network;
  String agencyCode;
}

class GaugeLocation extends Decodable {
  GaugeLocation.decode(Map<String, dynamic> data): super.decode(data);
  GeoLocation geoLocation;
}

class GeoLocation extends Decodable {
  GeoLocation.decode(Map<String, dynamic> data): super.decode(data);
  double latitude;
  double longitude;
}

class GaugeVariable extends Decodable {
  GaugeVariable.decode(Map<String, dynamic> data): super.decode(data);
  String variableName;
  List<GaugeVariableCode> variableCode;
}

class GaugeValues extends Decodable {
  GaugeValues.decode(Map<String, dynamic> data): super.decode(data);
  List<GaugeValue> value;
}

class GaugeValue extends Decodable {
  GaugeValue.decode(Map<String, dynamic> data): super.decode(data);
  String value;
  String dateTime;
}

class GaugeVariableCode extends Decodable {
  GaugeVariableCode.decode(Map<String, dynamic> data): super.decode(data);
  int variableID;
}