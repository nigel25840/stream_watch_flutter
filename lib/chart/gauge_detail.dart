import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'dart:core';
import 'package:streamwatcher/chart/chart_manager.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class GaugeDetail extends StatefulWidget {
  final String gaugeId;
  final String gaugeName;
  GaugeDetail({this.gaugeId, this.gaugeName});
  _GaugeDetail createState() => _GaugeDetail();
}

class _GaugeDetail extends State<GaugeDetail> {
  ChartManager mgr = ChartManager();
  bool refresh = false;
  bool isFavorite = true;
  int segmentedControlIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STREAM WATCH"),
        actions: <Widget>[],
      ),
      body: FutureBuilder(
          future: mgr.getGaugeData(widget.gaugeId, refresh: false),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.gaugeName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mgr.getCurrentStats(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          )),
                    ],
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * .5,
                      alignment: Alignment(0.0, 0.0),
                      color: Colors.lightBlueAccent,
                      child: charts.TimeSeriesChart(
                        mgr.isCfs ? mgr.seriesFlowData : mgr.seriesStageData,
                        animate: true,
                        animationDuration: Duration(milliseconds: 700),
                        primaryMeasureAxis: charts.NumericAxisSpec(
                            tickProviderSpec:
                                charts.BasicNumericTickProviderSpec(
                                    zeroBound: false,
                                    dataIsInWholeNumbers: false,
                                    desiredMaxTickCount: 8,
                                    desiredMinTickCount: 5),
                            renderSpec: charts.GridlineRendererSpec(
                              tickLengthPx: 0,
                              labelOffsetFromAxisPx: 5,
                            )),
                      )),
                  Visibility(
                    visible: mgr.containsAllData,
                    child: MaterialSegmentedControl(
                      horizontalPadding: EdgeInsets.all(20),
                      children: {0: Text("CFS"), 1: Text("  Stage in feet  ")},
                      selectionIndex: segmentedControlIndex,
                      borderRadius: 10.0,
                      selectedColor: Colors.blue,
                      unselectedColor: Colors.white,
                      onSegmentChosen: (index) {
                        setState(() {
                          mgr.isCfs = !mgr.isCfs;
                          segmentedControlIndex = index;
                        });
                      },
                    ),
                  )
                ],
              );
            } else {
              return Align(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.arrow_upward),
        animatedIcon: AnimatedIcons.ellipsis_search,
        animatedIconTheme: IconThemeData(size: 22.0),
        onOpen: () => print("OPENING GUGE MENU"),
        onClose: () => print("CLOSING GUGE MENU"),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(Icons.refresh),
            backgroundColor: Colors.blue,
            onTap: () {
              setState(() {
                mgr.isCfs = true;
                segmentedControlIndex = 0;
                mgr.seriesStageData = null;
                mgr.seriesFlowData = null;
                mgr.getGaugeData(widget.gaugeId, refresh: true);
              });
            },
            labelBackgroundColor: Colors.blue,
          ),
          SpeedDialChild(
            child: Icon(isFavorite ? Icons.star_border : Icons.star),
            backgroundColor: Colors.blue,
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            labelBackgroundColor: Colors.blue,
          ),
        ],
      ),


//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.refresh),
//        onPressed: () {
//          setState(() {
//            mgr.isCfs = true;
//            segmentedControlIndex = 0;
//            mgr.seriesStageData = null;
//            mgr.seriesFlowData = null;
//            mgr.getGaugeData(widget.gaugeId, refresh: true);
//          });
//        },
//      ),
      endDrawer: RFDrawer(),
    );
  }
}

class RFSegmentedControl extends CupertinoSegmentedControl {}

//CupertinoSegmentedControl(
//padding: EdgeInsets.all(10.0),
//children: { 0: Text("CFS"), 1: Text("  Stage in feet  ") },
//selectedColor: Colors.lightBlueAccent,
//onValueChanged: (value) {
//setState(() {
//mgr.isCfs = !mgr.isCfs;
//});
//},
//)
