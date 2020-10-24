import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
      viewModel.reloading = true;
      viewModel.setReferenceModel(widget.referenceModel);
    });
  }

  Future<void> _loading() async {
    final ProgressDialog prog = ProgressDialog(context);
    prog.style(
        message:
            "Downloading gauge details for ${widget.referenceModel.gaugeName}",
        messageTextStyle: TextStyle(fontSize: 14, color: Colors.white),
        backgroundColor: Colors.indigo);
    prog.show();
  }
  //Center(child: CircularProgressIndicator()),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RLAppBar(
          titleText: Text('Gauge Detail'),
        ),
        body: Center(
          child: Consumer<GaugeDetailViewModel>(
            builder: (context, model, child) => Stack(
              children: [
                Center(
                  child: Visibility(
                      visible: model.reloading,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Loading details for'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${widget.referenceModel.gaugeName}'),
                          )
                        ],
                      )),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.getGaugeName()),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('CFS values'),
                          Text(model
                              .getUltimateValue(cfs: true, highValue: true)
                              .toString()),
                          Text(model
                              .getUltimateValue(cfs: true, highValue: false)
                              .toString()),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Stage values'),
                          Text(model
                              .getUltimateValue(cfs: false, highValue: true)
                              .toString()),
                          Text(model
                              .getUltimateValue(cfs: false, highValue: false)
                              .toString())
                        ],
                      ),
                    ),
                    Divider()
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
