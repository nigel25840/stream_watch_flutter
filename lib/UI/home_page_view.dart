import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/favorite_cell.dart';
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
  TextStyle buttonStyle =
      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500);

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

  CarouselSlider getSlider(FavoritesViewModel model) {
    return CarouselSlider(
      options: CarouselOptions(
        height: kCardHeight,
        autoPlay: autoPlay,
        autoPlayInterval: Duration(seconds: 8),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 1.0,
        enlargeCenterPage: false,
      ),
      items: getFavoriteCards(model.favorites, context).map((card) {
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

  List<FavoriteCard> getFavoriteCards(
      List<String> items, BuildContext context) {
    if (items == null) return [];
    List<FavoriteCard> cards = [];
    for (int index = 0; index < items.length; index++) {
      cards.add(FavoriteCard(items[index], Key(items[index]), false, false));
    }
    return cards;
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

    return Scaffold(
      appBar: AppBar(
        title: Text("River Watch"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 8,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/splash.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Row(
                  children: [
                    SizedBox(width: size.width * .05),
                    SizedBox(
                      width: size.width * .4,
                      child: OutlineButton(
                          highlightedBorderColor: Colors.blue,
                          disabledBorderColor: Colors.lightBlue,
                          onPressed: () {
                            _handleTap(StatePicker(title: "Choose a State"));
                          },
                          color: Colors.white,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search),
                              Text('Search', style: buttonStyle),
                            ],
                          )),
                    ),
                    SizedBox(width: size.width * .1),
                    SizedBox(
                      width: size.width * .4,
                      child: OutlineButton(
                          highlightedBorderColor: Colors.blue,
                          disabledBorderColor: Colors.lightBlue,
                          onPressed: () {
                            _handleTap(FavoritesView());
                          },
                          color: Colors.blue,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star_border),
                              Text('Favorites', style: buttonStyle),
                            ],
                          )),
                    ),
                    SizedBox(width: size.width * .05),
                  ],
                )),
            Flexible(
                flex: 2,
                child: Consumer<FavoritesViewModel>(
                  builder: (context, model, child) => SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: getSlider(model)),
                )),
          ],
        ),
      ),
      endDrawer:
          RFDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
