import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/UI/help.dart';
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

  Widget showNoFavoritesView() {
    TextStyle style = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Currently you have not added any favorites.',
                textAlign: TextAlign.left, style: style),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Visit the Help section to learn more about adding and managing favorites',
                style: style),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return HelpView();
                      }));
                    },
                    padding: EdgeInsets.only(left: 20, right: 20, top:10, bottom: 10),
                    color: Colors.lightBlueAccent,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black45,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.help, size: 28,),
                          SizedBox(width: 8,),
                          Text('Open Help...', style: style,)
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool reload = refreshAll;
    refreshAll = false;

    if (viewModel.favoriteModels.length < 1) {
      return Consumer<FavoritesViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Favorites'),
          ),
          body: showNoFavoritesView(),
          endDrawer: RFDrawer(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Consumer<FavoritesViewModel>(
          builder: (context, model, child) => Container(
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: model.favorites.length,
                    itemBuilder: (context, index) {
                      String gaugeId = model.favorites[index];
                      Key key = Key(model.favorites[index]);
                      return FavoriteCard(gaugeId, key, reload, true);
                    },
                  ),
                  onRefresh: _loadData,
                ),
              )),
      endDrawer: RFDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
        onPressed: _refreshButtonTapped,
      ),
    );

    // if(viewModel.favoriteModels.length < 1) {
    //   return CupertinoAlertDialog(
    //     title: Text('Notice!'),
    //     content: Text('Currently you have not added any favorites. Visit the Help section to learn more about managing favorites'),
    //     actions: [
    //       FlatButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
    //       FlatButton(onPressed: () {
    //         Navigator.push(context, MaterialPageRoute(builder: (context) {
    //           return HelpView();
    //         }));
    //       }, child: Text('Help'))
    //     ],
    //   );
    // } else {
    //   return Consumer<FavoritesViewModel>(
    //     builder: (context, model, child) => Scaffold(
    //       appBar: AppBar(
    //         title: Text('Favorites'),
    //       ),
    //       body: RefreshIndicator(
    //         child: ListView.builder(
    //           itemCount: model.favorites.length,
    //           itemBuilder: (context, index) {
    //             String gaugeId = model.favorites[index];
    //             Key key = Key(model.favorites[index]);
    //             return FavoriteCard(gaugeId, key, reload, true);
    //           },
    //         ),
    //         onRefresh: _loadData,
    //       ),
    //       endDrawer: RFDrawer(),
    //       floatingActionButton: FloatingActionButton(
    //         backgroundColor: Colors.red,
    //         child: Icon(Icons.refresh),
    //         onPressed: _refreshButtonTapped,
    //       ),
    //     ),
    //   );
    // }
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
