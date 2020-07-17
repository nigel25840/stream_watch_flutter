import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/chart/gauge_detail.dart';
import 'package:streamwatcher/dataServices/data_provider.dart';
import 'package:streamwatcher/model/gauge_model.dart';

import 'favorite_cell.dart';

class FavoritesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritesView();
}

class _FavoritesView extends State<FavoritesView> {
  List<String> favorites;

  Future _getFavorites() async {
    List<String> faveIds = await Storage.getList(kFavoritesKey);
    favorites = faveIds;
    return faveIds;
  }

  ScrollablePositionedList _faveListView(
      AsyncSnapshot snapshot, BuildContext context) {
    var faves = snapshot.data;
    var list = ScrollablePositionedList.builder(
        itemCount: faves.length,
        itemBuilder: (context, index) {
          return FavoriteCell(faves[index], Key(faves[index]));
        });
    return list;

    ReorderableListView _roListView() {

    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
          () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final String item = favorites.removeAt(oldIndex);
        favorites.insert(newIndex, item);
      },
    );
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
            return ReorderableListView (
              onReorder: (val1, val2) {
                this._onReorder(val1, val2);
              },
              children: List.generate(favorites.length, (index){
                String key = favorites[index];
                FavoriteCell cell = FavoriteCell(key, Key(key));
                return cell;
              }),
              scrollDirection: Axis.vertical,
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

//Padding(
//padding: const EdgeInsets.all(8.0),
//child: _faveListView(snapshot, context),

