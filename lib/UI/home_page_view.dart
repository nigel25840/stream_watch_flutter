import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/favorite_listview_cell.dart';
import 'package:streamwatcher/UI/state_picker.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';
import 'drawer.dart';
import 'favorites_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle buttonStyle = TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500);

  Future<void> _initializePreferences() async {
    var faves = await Storage.getList(kFavoritesKey);
    if (faves == null) {
      await Storage.initializeList(kFavoritesKey);
    }
  }

  FavoritesViewModel viewModel;
  bool animate = true;
  var autoPlay = true;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    // setState(() async {
      viewModel = await Provider.of<FavoritesViewModel>(context, listen: false);
      await viewModel.loadFavorites();
    // });
  }

  // model is passed to this function through a consumer in the scaffold
  // to ensure that it is the same model that is part of the provider
  CarouselSlider getSlider(FavoritesViewModel model) {
    return CarouselSlider(
      options: CarouselOptions(
        height: kCardHeight,
        // autoPlay: (viewModel != null) ? viewModel.favorites.length > 1: true,
        autoPlay: autoPlay,
        autoPlayInterval: Duration(seconds: 7),
        autoPlayAnimationDuration: Duration(milliseconds: 500),
        viewportFraction: 1.0,
        enlargeCenterPage: false,
      ),
      items: _getFavoriteCells(model.favorites, context).map((card) {
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(height: kCardHeight, child: card),
            );
          },
        );
      }).toList(),
    );
  }

  List<FavoriteCell> _getFavoriteCells(List<String> items, BuildContext context) {
    if (items == null) return [];
    List<FavoriteCell> cells = [];
    for (int index = 0; index < items.length; index++) {
      cells.add(FavoriteCell(gaugeId: items[index], key: UniqueKey(), isDismissable: false,));
    }
    return cells;
  }

  _handleTap(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  @override
  Widget build(BuildContext context) {
    _initializePreferences();
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/splashImage.png"), fit: BoxFit.fitWidth)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        title: Text("River Watch"),
      ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * .5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: size.width * .48,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black45, width: 2.0, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        _handleTap(StatePicker(title: "Choose a State"));
                      },
                      color: Colors.white.withAlpha(150),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search),
                          Text('Search', style: buttonStyle),
                        ],
                      )),
                ),
                Container(
                  width: size.width * .48,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black45, width: 2.0, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        _handleTap(FavoritesView());
                      },
                      color: Colors.white.withAlpha(150),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_border),
                          Text('Favorites', style: buttonStyle),
                        ],
                      )),
                ),
              ],
            ),
            Consumer<FavoritesViewModel>(
              builder: (context, model, child) => getSlider(model),
            ),
          ],
        ),
        endDrawer: RFDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
