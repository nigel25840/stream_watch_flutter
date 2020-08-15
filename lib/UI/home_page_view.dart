import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/favorite_cell.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/model/favorite_model%202.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _initializePreferences() async {
    var faves = await Storage.getList(kFavoritesKey);
    if (faves == null) {
      await Storage.initializeList(kFavoritesKey);
    }
  }

  FavoritesViewModel viewModel;
  List<FavoriteCard> cards;
  bool animate = true;
  var autoPlay = true;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    setState(() {
      viewModel = Provider.of<FavoritesViewModel>(context, listen: false);
      viewModel.loadFavorites();
    });
  }

  CarouselSlider getSlider(List<int> items) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 120.0,
        autoPlay: autoPlay,
        autoPlayInterval: Duration(seconds: 8),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 1.0,
        enlargeCenterPage: false,
      ),
      items: getFavoriteCards(viewModel.favorites, context).map((card) {
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: card,
            );
          },
        );
      }).toList(),
    );
  }

  List<FavoriteCard> getFavoriteCards(List<String> items, BuildContext context) {
    if (items == null) return [];
    List<FavoriteCard> cards = [];
    for (int index = 0; index < items.length; index++) {
      FavoriteCard card = FavoriteCard(items[index], Key(items[index]), true);
      card.isDismissable = false;
      cards.add(card);
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    _initializePreferences();

    List<int> items = [1,2,3,4];

    print('********************************************');
    print(getFavoriteCards(viewModel.favorites, context));
    print('********************************************');

    return Scaffold(
      appBar: AppBar(
        title: Text("River Watch"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 8,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: Text('Home Page Title View'),
                ),
              ),
            ),
            Flexible(
                flex: 2,
                child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: getSlider(items))),
          ],
        ),
      ),
      endDrawer:
          RFDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
