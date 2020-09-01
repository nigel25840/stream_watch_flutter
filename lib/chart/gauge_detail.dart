import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'dart:core';
import 'package:streamwatcher/chart/chart_viewmodel.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:streamwatcher/model/favorite_model.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

import '../Util/constants.dart';

class GaugeDetail extends StatefulWidget {
  final String gaugeId;
  final String gaugeName;
  final Function() notifyParent;

  GaugeDetail({this.gaugeId, this.gaugeName, this.notifyParent});
  _GaugeDetail createState() => _GaugeDetail();
}

class _GaugeDetail extends State<GaugeDetail> {
  TextStyle headingStyle = TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);
  TextStyle dataStyle = TextStyle(fontSize: 12.0);
  TextStyle readingStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0);
  ChartViewModel mgr = ChartViewModel();
  bool refresh = false;
  bool isFavorite;
  int segmentedControlIndex = 0;
  List<String> faves;
  int animationDuration = 700;

  FavoritesViewModel favesVM; // serviceLocator<FavoritesViewModel>();
  FavoriteModel model;

  @override
  initState() {
    favesVM = Provider.of<FavoritesViewModel>(context, listen: false);
    super.initState();
  }

  Future<void> confirmAddRemoveFavorite(bool favorite, String gaugeId) async {
    String deleteMessage =
        'You\'re about to remove ${widget.gaugeName} from your favorites. Would you like to continue?';
    String successMessage =
        '${widget.gaugeName} was just added to you favorites';
    List<FlatButton> buttons = [];

    var okButton = FlatButton(
      child: Text(
        'OK',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    var approveRemovalButton = FlatButton(
      child: Text(
        'Remove',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      onPressed: () {
        animationDuration = 0;
        favesVM.deleteFavorite(widget.gaugeId);
        Navigator.pop(context);
      },
    );

    var cancelButton = FlatButton(
      child: Text('Cancel',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
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

  Future<void> showSaveFavoriteError(BuildContext context) async {
    Widget okButton = FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Error saving gauge'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('${widget.gaugeName} is malfunctioning and cannot be saved to favorites. Please contact the USGS regarding this gauge is the problem persists')
                ],
              ),
            ),
            actions: [okButton],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gaugeName,
          style: headingStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
        ),
        actions: <Widget>[],
      ),
      body: FutureBuilder(
          future: mgr.getGaugeData(widget.gaugeId, refresh: false),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${mgr.getCurrentValue('stage')}', style: readingStyle,
                        ),
                        Text('${mgr.getCurrentValue('')}', style: readingStyle,)
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * .5,
                          alignment: Alignment(0.0, 0.0),
                          color: Colors.lightBlueAccent,
                          child: charts.TimeSeriesChart(
                            mgr.isCfs ? mgr.seriesFlowData : mgr.seriesStageData,
                            animate: true,
                            animationDuration:
                                Duration(milliseconds: animationDuration),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text('3 day values', style: TextStyle(fontWeight: FontWeight.bold),),),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Low flow: ${mgr.ultimateStages != null ? mgr.ultimateStages.first : 'N/A'}', style: dataStyle,),
                                      SizedBox(height: 4,),
                                      Text('High flow: ${mgr.ultimateStages != null ? mgr.ultimateStages.last : 'N/A'}', style: dataStyle,),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Low flow: ${mgr.ultimateFlows != null ? mgr.ultimateFlows.first : 'N/A'}', style: dataStyle,),
                                      SizedBox(height: 4,),
                                      Text('High flow: ${mgr.ultimateFlows != null ? mgr.ultimateFlows.last : 'N/A'}', style: dataStyle,),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],

                  ),
                  Visibility(
                    visible: mgr.containsAllData,
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
        onOpen: () { },
        onClose: () { },
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
              bool error = false;
              if (!mgr.isFavorite) {
                setState(() {
                  try {
                    animationDuration = 0;
                    FavoriteModel model = FavoriteModel(widget.gaugeId);
                    model.favoriteName = widget.gaugeName;
                    double flow = -9999;
                    try {
                      if (mgr.gaugeFlowReadings != null) {
                        if (mgr.gaugeFlowReadings.last != null) {
                          if (mgr.gaugeFlowReadings.last.dFlow != null) {
                            flow = mgr.gaugeFlowReadings.last.dFlow;
                          }
                        }
                      }
                    } catch (ex) { }

                    double stage = (mgr.gaugeStageReadings != null) ? mgr.gaugeStageReadings.last.dFlow:0;
//                    double flow = (mgr.gaugeFlowReadings != null) ? mgr.gaugeFlowReadings.last.dFlow:0;

                    model.currentFlow = flow;
                    model.currentStage = stage;
                    model.lastUpdated = DateTime.now();

                    favesVM.addFavorite(widget.gaugeId, model);
                  } catch (e) {
                    showSaveFavoriteError(context);
                    error = true;
                  }
                });
              }
              if (!error)
                confirmAddRemoveFavorite(mgr.isFavorite, widget.gaugeId);
            },
            labelBackgroundColor: Colors.blue,
          ),
        ],
      ),

      // TODO: revive this button in next version of app
//          SpeedDialChild(
//              child: Icon(Icons.settings),
//              onTap: () {
//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return GaugePreferences(widget.gaugeName, widget.gaugeId);
//                }));
//              })

      endDrawer: RFDrawer(),
    );
  }
}
