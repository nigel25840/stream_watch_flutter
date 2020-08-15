import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/Util/Storage.dart';
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

  @override
  Widget build(BuildContext context) {
    _initializePreferences();

    List<int> items = [1,2,3,4];

    return Scaffold(
      appBar: AppBar(
        title: Text("River Watch"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 6,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: Text('Home Page Title View'),
                ),
              ),
            ),
            Flexible(
                flex: 4,
                child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: 120.0,
                          autoPlay: (items.length > 1),
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 1.0,
                      ),
                      items: items.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent),
                                child: Text(
                                  'text $i',
                                  style: TextStyle(fontSize: 16.0),
                                ));
                          },
                        );
                      }).toList(),
                    )))
          ],
        ),
      ),
      endDrawer:
          RFDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
