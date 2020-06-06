import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/constants.dart';
import 'dart:core';

class GaugeDetail extends StatefulWidget {
  final String gaugeId;
  final String gaugeName;
  GaugeDetail({this.gaugeId, this.gaugeName});

  _GaugeDetail createState() => _GaugeDetail();
}

class _GaugeDetail extends State<GaugeDetail> {
  String getGauge() {
    return widget.gaugeId;
  }

  @override
  Widget build(BuildContext context) {
    print(getGauge());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gaugeName),
      ),
      body: Center(
        child: Text(widget.gaugeName),
      ),
    );
  }
}
