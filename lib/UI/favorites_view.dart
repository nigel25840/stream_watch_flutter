import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';

class FavoritesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritesView();
}

class _FavoritesView extends State<FavoritesView> {
  List<String> favorites;

  Future _getFavorites() async {
    List<String> faveIds = await Storage.getList(kFavoritesKey);
    return faveIds;
  }

  ScrollablePositionedList _faveListView(
      AsyncSnapshot snapshot, BuildContext context) {
    var faves = snapshot.data;
    var list = ScrollablePositionedList.builder(
        itemCount: faves.length,
        itemBuilder: (context, index) {
          return FavoriteCell(faves[index]);
        });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('=Favorites='),
      ),
      body: FutureBuilder(
        future: _getFavorites(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _faveListView(snapshot, context),
            );
          } else {
            return Align(child: CircularProgressIndicator());
          }
        },
      ),
      endDrawer: RFDrawer(),
    );
  }
}

class FavoriteCell extends StatefulWidget {
  final String favoriteGaugeId;
  _FavoriteCell createState() => _FavoriteCell();
  FavoriteCell(this.favoriteGaugeId);
}

class _FavoriteCell extends State<FavoriteCell> {
  var _cellData;

  TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle subStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

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

  Card _faveCardView(AsyncSnapshot snapshot, BuildContext context) {
    GaugeModel model = snapshot.data;
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
                  Text(
                      '${model.lastFlowReading != null ? model.lastFlowReading.round().toString() + 'cfs' : 'N/A'}',
                      style: subStyle),
                  Text(
                      '${model.lastStageReading != null ? model.lastStageReading.toString() + 'ft' : 'N/A'}',
                      style: subStyle),
                  Icon(Icons.arrow_forward)
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
        //GaugeModel fave = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          return _faveCardView(snapshot, context); //Text(fave.gaugeName);
        } else {
          return Align(
            child: CircularProgressIndicator(),
            widthFactor: 2,
          );
        }
      },
    );
  }
}
