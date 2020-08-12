
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/services/service_locator.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';
import 'favorite_cell.dart';

class FavoritesView extends StatefulWidget {

  _FavoritesView favesState = new _FavoritesView();

  @override
  _FavoritesView createState() => favesState;
}

class _FavoritesView extends State<FavoritesView> {

  List<String> favorites;
  List<FavoriteCard> faveCards = [];
  int cardCount;
  FavoritesViewModel viewModel = serviceLocator<FavoritesViewModel>();

  @override
  void initState() {
    viewModel.loadFavorites();
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('=Favorites='),
      ),
      body: buildNotifiedListListView(),
      endDrawer: RFDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget buildNotifiedListListView(){
    return ChangeNotifierProvider<FavoritesViewModel> (
      create: (context) => viewModel,
      child: Consumer<FavoritesViewModel>(
        builder: (context, model, index) => ListView.builder(
          itemCount: viewModel.favorites.length,
          itemBuilder: (context, index){
            return FavoriteCard(viewModel.favorites[index], Key(viewModel.favorites[index]));
          },
        ),
      )
    );
  }
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
