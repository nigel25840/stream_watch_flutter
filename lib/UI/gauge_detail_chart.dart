import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/RLAppBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/model/gauge_detail_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/gauge_detail_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'chart_view.dart';

class GaugeDetailChart extends StatefulWidget {
  GaugeReferenceModel referenceModel;
  GaugeDetailChart({this.referenceModel});

  @override
  _GaugeDetailChartState createState() => _GaugeDetailChartState();
}

class _GaugeDetailChartState extends State<GaugeDetailChart> {
  GaugeDetailViewModel viewModel;
  TextStyle whiteStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white);
  TextStyle detailStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 14, color: Colors.white);

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() {
    viewModel = Provider.of<GaugeDetailViewModel>(context, listen: false);
    viewModel.reloading = true;
    viewModel.setReferenceModel(widget.referenceModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: RLAppBar(
          titleText: Text('Gauge Detail'),
        ),
        body: Center(
          child: Consumer<GaugeDetailViewModel>(
            builder: (context, model, _) => Stack(
              children: [
                Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(20.0))),
                        child: ChartView(refModel: widget.referenceModel, viewModel: viewModel),
                      ),
                    ),
                    Flexible(
                        child: Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:  const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text('3 day values', style: whiteStyle,),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Low stage: ${model.lowStage} ft', style: detailStyle,),
                                          SizedBox(height: 4,),
                                          Text('High stage: ${model.highStage} ft', style: detailStyle)
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Low flow: ${model.lowFlow} cfs', style: detailStyle,),
                                          SizedBox(height: 4,),
                                          Text('High flow: ${model.highFlow} cfs', style: detailStyle)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                        )
                    )
                  ],
                ),
                Center(
                  child: Visibility(
                      visible: model.reloading,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
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
                        ),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}

/*
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
 */
