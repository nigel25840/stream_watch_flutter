import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class GaugePreferences extends StatefulWidget {
  final String gaugeName;
  final String gaugeId;
  GaugePreferences(this.gaugeName, this.gaugeId);

  _GaugePreferences createState() => _GaugePreferences();
}

class _GaugePreferences extends State<GaugePreferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gauge Preferences'),
        ),
        body: Column(
          children: [Text(widget.gaugeName), Text(widget.gaugeId)],
        ));
  }
}
