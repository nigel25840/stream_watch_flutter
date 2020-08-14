import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

class GaugePreferences extends StatefulWidget {
  final String gaugeName;
  final String gaugeId;
  GaugePreferences(this.gaugeName, this.gaugeId);
  _GaugePreferences createState() => _GaugePreferences();
}

class _GaugePreferences extends State<GaugePreferences> {

  FavoritesViewModel favesVM;

  @override
  void initState() {
    favesVM = Provider.of<FavoritesViewModel>(context, listen: false);
    super.initState();
  }

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
