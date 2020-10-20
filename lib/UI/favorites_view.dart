import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/RLAppBar.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/UI/favorite_listview_cell.dart';
import 'package:streamwatcher/UI/help.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

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

  Future<void> _refreshButtonTapped() async {
    final ProgressDialog prog = ProgressDialog(context);
    prog.style(
      message: "Downloading & updating gauge data from USGS...",
      messageTextStyle: TextStyle(fontSize: 14, color: Colors.white),
      backgroundColor: Colors.indigo
    );
    prog.show();
    refreshAll = true;
    await viewModel.refreshAllFavorites().then((_) => { prog.hide() });
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HelpView();
                      }));
                    },
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
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
                          Icon(
                            Icons.help,
                            size: 28,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Open Help...',
                            style: style,
                          )
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
      appBar: RLAppBar(Text('Favorites'), 60.0),
      body: Consumer<FavoritesViewModel>(
          builder: (context, model, child) => Container(
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: model.favorites.length,
                    itemBuilder: (context, index) {
                      String gaugeId = model.favorites[index];
                      Key key = Key(model.favorites[index]);
                      //return FavoriteCard(gaugeId, key, reload, true);
                      return FavoriteCell(
                          gaugeId: gaugeId,
                          key: UniqueKey(),
                          isDismissable: true,
                          reload: reload);
                    },
                  ),
                  color: Colors.transparent,
                  strokeWidth: 0,
                  onRefresh: _refreshButtonTapped,
                ),
              )),
      endDrawer: RFDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            _refreshButtonTapped();
          });
        },
      ),
    );
  }
}

