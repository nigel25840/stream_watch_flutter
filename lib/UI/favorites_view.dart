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
            return _faveListView(snapshot, context);
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

  Future<GaugeModel> _getFavorite() async {
    _cellData = await DataProvider().gaugeJson(widget.favoriteGaugeId, 1);
    var timeSeries = _cellData['value']['timeSeries'];
    //value.timeSeries[0].sourceInfo.siteName
    print('SITE NAME');
    print(timeSeries[0]['sourceInfo']['siteName']);
    return await GaugeModel(gaugeName: timeSeries[0]['sourceInfo']['siteName'], gaugeState: 'DC', gaugeId: '1234');
  }

  Card _faveCardView(AsyncSnapshot snapshot, BuildContext context) {
    GaugeModel model = snapshot.data;
    var card = Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.gaugeName),
                Text(model.gaugeState),
              ],
            ),
          ),
          Icon(Icons.arrow_forward)
        ],
      ),
    );
    return card;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getFavorite(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //GaugeModel fave = snapshot.data;
        if(snapshot.connectionState == ConnectionState.done) {
          return _faveCardView(snapshot, context); //Text(fave.gaugeName);
        } else {
          return Align(child: CircularProgressIndicator(), widthFactor: 2,);
        }
      },
    );
  }

}