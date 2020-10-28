import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class GaugeSelectorViewModel extends ChangeNotifier {
  List<GaugeReferenceModel> stateList;
}