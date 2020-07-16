import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/chart/gauge_detail.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class FavoriteCell extends StatefulWidget {
  final String favoriteGaugeId;
  _FavoriteCell createState() => _FavoriteCell();
  FavoriteCell(this.favoriteGaugeId);
}

class _FavoriteCell extends State<FavoriteCell> {
  var _cellData;

  TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle subStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  Future<GaugeModel> _getFavorite() async {
    _cellData = await DataProvider().gaugeJson(widget.favoriteGaugeId, 2);
    var timeSeries = _cellData['value']['timeSeries'];
    double lastFlowReading;
    double lastStageReading;

    for (int index = 0; index < timeSeries.length; index++) {
      String varName = timeSeries[index]['variable']['variableName'];
      try {
        if (varName.toLowerCase().contains('streamflow')) {
          var flowVal = timeSeries[index]['values'][0]['value'][0]['value'];
          lastFlowReading = double.parse(flowVal);
        } else if (varName.toLowerCase().contains('gage')) {
          var stageVal = timeSeries[index]['values'][0]['value'][0]['value'];
          lastStageReading = double.parse(stageVal);
        }
      } catch (e) {}
    }

    GaugeModel model = await GaugeModel(
        gaugeName: timeSeries[0]['sourceInfo']['siteName'],
        gaugeId: widget.favoriteGaugeId);
    model.lastFlowReading = lastFlowReading;
    model.lastStageReading = lastStageReading;

    return model;
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
                      Text(model.gaugeName, style: titleStyle),
                      Text(model.gaugeId),
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
                    flex: 3,
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
                    flex: 3,
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
                      flex: 4,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      )
                  )
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
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GaugeDetail(
                  gaugeId: gaugeModel.gaugeId,
                  gaugeName: gaugeModel.gaugeName,
                );
              }));
            },
            child: _faveCardView(gaugeModel, context),
          ); //Text(fave.gaugeName);
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