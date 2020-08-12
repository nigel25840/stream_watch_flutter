import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'dart:core';
import 'package:streamwatcher/chart/chart_viewmodel.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Util/constants.dart';

class GaugeDetail extends StatefulWidget {
  final String gaugeId;
  final String gaugeName;
  final Function() notifyParent;

  GaugeDetail({this.gaugeId, this.gaugeName, this.notifyParent});
  _GaugeDetail createState() => _GaugeDetail();
}

class _GaugeDetail extends State<GaugeDetail> {
  ChartViewModel mgr = ChartViewModel();
  bool refresh = false;
  bool isFavorite;
  int segmentedControlIndex = 0;
  List<String> faves;
  int animationDuration = 700;

  Future<List<String>> getFavorites(String id) async {
    List<String> favorites = await Storage.getList(kFavoritesKey);
    return favorites;
  }

  Future<void> confirmAddRemoveFavorite(bool favorite, String gaugeId) async {
    String deleteMessage = 'You\'re about to remove ${widget.gaugeName} from your favorites. Would you like to continue?';
    String successMessage = '${widget.gaugeName} was just added to you favorites';
    List<FlatButton> buttons = [];

    var okButton = FlatButton(
      child: Text('OK',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    var approveRemovalButton = FlatButton(
      child: Text('Remove',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      onPressed: () {
        setState(() {
          DartNotificationCenter.post(channel: kFavoriteUpdateNotification);
          animationDuration = 0;
          mgr.removeFavorite(widget.gaugeId);
          Navigator.pop(context);
        });
      },
    );

    var cancelButton = FlatButton(
      child: Text('Cancel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
      onPressed: () => Navigator.pop(context),
    );

    if (favorite) {
      // if this IS a favorite, apply removal buttons
      buttons.add(cancelButton);
      buttons.add(approveRemovalButton);
    } else {
      // otherwise show a confirmation button
      buttons.add(okButton);
    }

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(favorite ? 'Confirm?' : 'Success!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text(!favorite ? successMessage : deleteMessage)],
              ),
            ),
            actions: buttons,
          );
        });
  }

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
                        animationDuration: Duration(milliseconds: animationDuration),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MaterialSegmentedControl(
                          horizontalPadding: EdgeInsets.all(20),
                          children: {
                            0: Text("CFS"),
                            1: Text("  Stage in feet  ")
                          },
                          selectionIndex: segmentedControlIndex,
                          borderRadius: 10.0,
                          selectedColor: Colors.blue,
                          unselectedColor: Colors.white,
                          onSegmentChosen: (index) {
                            setState(() {
                              animationDuration = 700;
                              mgr.isCfs = !mgr.isCfs;
                              segmentedControlIndex = index;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Align(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.keyboard_arrow_up),
        animatedIconTheme: IconThemeData(size: 22.0),
        onOpen: () {
          print("OPENING GAUGE MENU");
        },
        onClose: () {
          print("CLOSING GAUGE MENU");
        },
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(Icons.refresh),
            backgroundColor: Colors.blue,
            onTap: () {
              setState(() {
                segmentedControlIndex = 0;
                mgr.seriesStageData = null;
                mgr.seriesFlowData = null;
                mgr.getGaugeData(widget.gaugeId, refresh: true);
              });
            },
            labelBackgroundColor: Colors.blue,
          ),
          SpeedDialChild(
            child: Icon(mgr.isFavorite ? Icons.star : Icons.star_border),
            backgroundColor: Colors.blue,
            onTap: () {
              if(!mgr.isFavorite) {
                setState(() {
                  animationDuration = 0;
                  mgr.addFavorite(widget.gaugeId);
                  DartNotificationCenter.post(channel: kFavoriteUpdateNotification);
                });
              }
              confirmAddRemoveFavorite(mgr.isFavorite, widget.gaugeId);
            },
            labelBackgroundColor: Colors.blue,
          ),
          SpeedDialChild(
            child: Icon(Icons.map),
            onTap: () {
              Navigator.pop(context, () {
                setState(() {});
              });
            }
          )
        ],
      ),
      endDrawer: RFDrawer(),
    );
  }
}