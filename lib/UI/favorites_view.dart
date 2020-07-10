import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/UI/drawer.dart';

class FavoritesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritesView();
}

class _FavoritesView extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('=Favorites='),
      ),
      body: Center(child: Text('*Favorites*')),
      endDrawer: RFDrawer(),
    );
  }
}
