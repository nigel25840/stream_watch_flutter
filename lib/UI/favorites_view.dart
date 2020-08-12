import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'favorite_cell.dart';

class FavoritesView extends StatefulWidget {

  FavoritesView(){
    DartNotificationCenter.subscribe(channel: kFavoriteUpdateNotification, observer: this, onNotification: (result) => _processNotification(result));
  }

  void _processNotification(String result) {
    print('RECEIVED NOTIFICATION ON $kFavoriteUpdateNotification CHANNEL ~ RESULT: $result');
    favesState.updateState();
  }

  _FavoritesView favesState = new _FavoritesView();

  @override
  _FavoritesView createState() => favesState;
//  State<StatefulWidget> createState() => _FavoritesView();
}

class _FavoritesView extends State<FavoritesView> {
  List<String> favorites;
  List<FavoriteCard> faveCards = [];
  int cardCount;

  void updateState() {
    print('UPDATING STATE');
    setState(() { });
  }

  Future _getFavorites() async {
    List<String> faveIds = await Storage.getList(kFavoritesKey);
    favorites = faveIds;
    return faveIds;
  }

  refresh() {
    setState(() {
      print('UPDATING FAVORITES VIEW');
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final String item = favorites.removeAt(oldIndex);
        favorites.insert(newIndex, item);

        final FavoriteCard card = faveCards.removeAt(oldIndex);
        faveCards.insert(newIndex, card);

        Storage.initializeList(kFavoritesKey, favorites);
      },
    );
    _updatePrefs(oldIndex, newIndex);
  }

  Future<void> _updatePrefs(int oldIndex, int newIndex) {}

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
            if (faveCards.length < 1) {
              return ReorderableListView(
                onReorder: this._onReorder,
                children: List.generate(favorites.length, (index) {
                  print("BUILDING FRESH LIST");
                  String key = favorites[index];
                  FavoriteCard cell = FavoriteCard(key, Key(key));
                  faveCards.add(cell);
                  return cell;
                }),
                scrollDirection: Axis.vertical,
              );
            } else {
              return ReorderableListView(
                  onReorder: this._onReorder,
                  children: List.generate(faveCards.length, (index) {
                    print("REORDERING CACHED LIST");
                    return faveCards[index];
                  }));
            }
          } else {
            return Align(child: CircularProgressIndicator());
          }
        },
      ),
      endDrawer: RFDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

//Padding(
//padding: const EdgeInsets.all(8.0),
//child: _faveListView(snapshot, context),
