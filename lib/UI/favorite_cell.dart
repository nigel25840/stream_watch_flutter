import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/chart/gauge_detail.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class FavoriteCard extends StatefulWidget {
  bool refresh;
  final String favoriteGaugeId;
  final Key key;
  GaugeModel model;
  _FavoriteCard createState() => _FavoriteCard();
  FavoriteCard(this.favoriteGaugeId, this.key, [this.refresh]);
}

class _FavoriteCard extends State<FavoriteCard> {
  var _cellData;

  TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle subStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  Future<GaugeModel> _getFavorite() async {
    if(widget.model == null) {
      print('MODEL IS REBUIDING');
      if (_cellData == null || widget.refresh) {
        _cellData = await DataProvider().gaugeJson(widget.favoriteGaugeId, 4);
      }
      var timeSeries = _cellData['value']['timeSeries'];
      double lastFlowReading;
      double lastStageReading;
      DateTime timeStamp;

      List<int> readingValues = [];
      bool gaugeRising = false;

      for (int index = 0; index < timeSeries.length; index++) {
        String varName = timeSeries[index]['variable']['variableName'];
        try {
          var values = timeSeries[index]['values'][0]['value'][0];
          if (varName.toLowerCase().contains('streamflow')) {
            var flowVal = values['value'];
            lastFlowReading = double.parse(flowVal);
            timeStamp = DateTime.parse(values['dateTime']);
          } else if (varName.toLowerCase().contains('gage')) {
            var stageVal = values['value'];
            lastStageReading = double.parse(stageVal);
            timeStamp = DateTime.parse(values['dateTime']);
            gaugeRising = _isTrendingUp(timeSeries[index]['values'][0]['value']);
          }
        } catch (e) {
          print(e.toString());
        }
      }

      if (widget.model == null) {
        widget.model = await GaugeModel(
            gaugeName: timeSeries[0]['sourceInfo']['siteName'],
            gaugeId: widget.favoriteGaugeId);
        widget.model.lastFlowReading = lastFlowReading;
        widget.model.lastStageReading = lastStageReading;
        widget.model.lastUpdated = timeStamp;
        widget.model.trendingUp = gaugeRising;
      }
    }

    return widget.model;
  }

  bool _isTrendingUp(List<dynamic> values) {
    int upCount = 0;
    int downCount = 0;
    for(int index = 0; index < values.length; index++) {
      if (index > 0) {
        double newVal = double.parse(values[index]['value']);
        double oldVal = double.parse(values[index - 1]['value']);
        if (newVal > oldVal) {
          upCount++;
        } else if (newVal < oldVal) {
          downCount++;
        }
      }
    }
    return upCount > downCount;
  }

  String formatTimeStamp(DateTime date, String format) {
    DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  Card _faveCardView(GaugeModel model, BuildContext context) {
    var card = Card(
        elevation: 2,
        color: Colors.tealAccent,
        shadowColor: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Column(

          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .95,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(model.gaugeName, style: titleStyle, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false,),
                                      Text('Last updated: ${formatTimeStamp(model.lastUpdated, 'MMM dd, yyyy')}')
                                    ],
                                  )
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${model.lastFlowReading != null ? model.lastFlowReading.round().toString() + 'cfs' : 'CFS: N/A'}',
                              style: subStyle),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              '${model.lastStageReading != null ? model.lastStageReading.toString() + 'ft' : 'Ft.: N/A'}',
                              style: subStyle),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Icon(model.trendingUp ? Icons.arrow_upward : Icons.arrow_downward),
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
    return card;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getFavorite(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        GaugeModel gaugeModel = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(gaugeModel.gaugeId),
                onDismissed: (dir) {
                  Storage.removeFromPrefs(kFavoritesKey, gaugeModel.gaugeId);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${gaugeModel.gaugeName} was removed from favorites')));
                },
                background: Container(
                  color: Colors.red,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'Deleting...',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GaugeDetail(
                        gaugeId: gaugeModel.gaugeId,
                        gaugeName: gaugeModel.gaugeName,
                      );
                    }));
                  },
                  child: _faveCardView(gaugeModel, context),
                ),
              ),
            ],
          );
        } else {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 2,
              color: Colors.tealAccent,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ));
        }
      },
    );
  }
}
