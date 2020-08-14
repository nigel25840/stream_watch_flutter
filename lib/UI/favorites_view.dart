import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';
import 'favorite_cell.dart';

class FavoritesView extends StatefulWidget {
  _FavoritesView favesState = new _FavoritesView();

  @override
  _FavoritesView createState() => favesState;
}

class _FavoritesView extends State<FavoritesView> {

  FavoritesViewModel viewModel;
  bool refreshAll = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _refreshButtonTapped() {
    refreshAll = true;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      viewModel = Provider.of<FavoritesViewModel>(context, listen: false);
      viewModel.loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool reload = refreshAll;
    refreshAll = false;
    return Consumer<FavoritesViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('=Favorites='),
        ),
        body: RefreshIndicator(
          child: ListView.builder(
            itemCount: model.favorites.length,
            itemBuilder: (context, index) {
              String gaugeId = model.favorites[index];
              Key key = Key(model.favorites[index]);
              return FavoriteCard(gaugeId, key, reload);
            },
          ),
          onRefresh: _loadData,
        ),
        endDrawer: RFDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.refresh),
          onPressed: _refreshButtonTapped,
        ),
      ),
    );
  }

//  void _onReorder(int oldIndex, int newIndex) {
//    setState(
//          () {
//        if (newIndex > oldIndex) {
//          newIndex -= 1;
//        }
//        final String item = favorites.removeAt(oldIndex);
//        favorites.insert(newIndex, item);
//
//        final FavoriteCard card = faveCards.removeAt(oldIndex);
//        faveCards.insert(newIndex, card);
//
//        Storage.initializeList(kFavoritesKey, favorites);
//      },
//    );
//  }

//  Widget buildNotifiedListListView(FavoritesViewModel vm) {
//    return ChangeNotifierProvider<FavoritesViewModel>(
//        create: (context) => viewModel,
//        child: Consumer<FavoritesViewModel>(
//          builder: (context, model, index) => ListView.builder(
//            itemCount: model.favorites.length,
//            itemBuilder: (context, index) {
//              return FavoriteCard(
//                  model.favorites[index], Key(model.favorites[index]));
//            },
//          ),
//        ));
//  }
}

//  Widget buildListView() {
//    return FutureBuilder(
//      future: _getFavorites(),
//      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        if (snapshot.connectionState == ConnectionState.done) {
//          if (faveCards.length < 1) {
//            return ReorderableListView(
//              onReorder: this._onReorder,
//              children: List.generate(favorites.length, (index) {
//                print("BUILDING FRESH LIST");
//                String key = favorites[index];
//                FavoriteCard cell = FavoriteCard(key, Key(key));
//                faveCards.add(cell);
//                return cell;
//              }),
//              scrollDirection: Axis.vertical,
//            );
//          } else {
//            return ReorderableListView(
//                onReorder: this._onReorder,
//                children: List.generate(faveCards.length, (index) {
//                  print("REORDERING CACHED LIST");
//                  return faveCards[index];
//                }));
//          }
//        } else {
//          return Align(child: CircularProgressIndicator());
//        }
//      },
//    );
//  }
