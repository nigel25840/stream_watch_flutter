
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/RLAppBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/gauge_detail_viewmodel.dart';

class GaugeDetailChart extends StatefulWidget {
  GaugeReferenceModel referenceModel;
  GaugeDetailChart({this.referenceModel});

  @override
  _GaugeDetailChartState createState() => _GaugeDetailChartState();
}

class _GaugeDetailChartState extends State<GaugeDetailChart> {

  GaugeDetailViewModel viewModel;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    setState(() {
      viewModel = Provider.of<GaugeDetailViewModel>(context, listen: false);
      viewModel.setReferenceModel(widget.referenceModel);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: RLAppBar(titleText: Text('Gauge Detail'),),
      body: Center(
        child: Consumer<GaugeDetailViewModel>(
          builder: (context, model, child) => Column (
            children: [
              Text(model.getGaugeName()),
              Text(model.getUltimateValue(true, true).toString())
            ],
          ),
        ),
      )
    );
  }
}
