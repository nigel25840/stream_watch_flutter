
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data_service.dart';

// GAUGE NAME:          value.timeSeries[0].sourceInfo.siteName
// GAUGE  IDENTIFIER:   value.timeSeries[0].sourceInfo.siteCode[0].value

class GaugeSelector extends StatefulWidget {
  final String stateAbbreviation;
  GaugeSelector({this.stateAbbreviation}){
    DataService().stateGauges(stateAbbreviation);
  }
  _GaugeSelector createState() => _GaugeSelector();
}

class _GaugeSelector  extends State<GaugeSelector> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kAllStates[widget.stateAbbreviation]),),
    );
  }
}