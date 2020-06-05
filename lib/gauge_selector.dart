
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GaugeSelector extends StatefulWidget {
  final String stateAbbreviation;
  GaugeSelector({this.stateAbbreviation}){
    print("GAUGE SELECTOR: $stateAbbreviation");
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