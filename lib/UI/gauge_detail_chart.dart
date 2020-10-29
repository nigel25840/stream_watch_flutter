import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/rl_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/gauge_detail_viewmodel.dart';

import 'chart_view.dart';
import 'drawer.dart';

class GaugeDetailChart extends StatefulWidget {
  GaugeReferenceModel referenceModel;
  GaugeDetailChart({this.referenceModel});

  @override
  _GaugeDetailChartState createState() => _GaugeDetailChartState();
}

class _GaugeDetailChartState extends State<GaugeDetailChart> {
  int segmentedControlIndex = 1; // this makes stage selected - stage is default
  GaugeDetailViewModel viewModel;
  TextStyle headingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white);
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
        endDrawer: RFDrawer(),
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
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(const Radius.circular(20.0))),
                          child: ChartView(refModel: widget.referenceModel, viewModel: viewModel, isCfs: viewModel.isCfs,),
                        ),
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
                                        child: Text('3 day values', style: headingStyle,),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Visibility (
                                    visible: model.containsFullDataset,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        MaterialSegmentedControl(
                                          horizontalPadding: EdgeInsets.only(top: 5, bottom: 0, left: 20, right: 20),
                                          children: {
                                            0: Text("CFS"),
                                            1: Text("  Stage in feet  ")
                                          },
                                          selectionIndex: segmentedControlIndex,
                                          borderRadius: 10.0,
                                          selectedColor: Colors.white,
                                          unselectedColor: Colors.blue,
                                          onSegmentChosen: (index) {
                                              viewModel.setReadingType(index);
                                              segmentedControlIndex = index;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),

                        )
                    ),
                  ],
                ),
                Center(
                  child: Visibility(
                      visible: model.reloading,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.5)
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoActivityIndicator(
                              radius: 50,
                            ),
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
