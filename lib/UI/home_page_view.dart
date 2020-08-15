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

    return Scaffold(
      appBar: AppBar(
        title: Text("River Watch"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Opening page'),
          ],
        ),
      ),
      endDrawer: RFDrawer(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
