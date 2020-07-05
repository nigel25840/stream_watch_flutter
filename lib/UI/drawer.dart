import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/UI/favorites_view.dart';
import 'package:streamwatcher/main.dart';

import '../state_picker.dart';

class RFDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RFDrawerState();
  var _key = GlobalKey<ScaffoldState>();

  _handleTapEvent() {
//    _key.currentState.dr
  }
}

class _RFDrawerState extends State<RFDrawer> {
  _handleTap(Widget widget) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  var style = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.blueGrey);
  var divider = Divider(color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Header', style: style),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: style),
              onTap: () {
                _handleTap(HomePage());
              },
            ),
            divider,
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites', style: style),
              onTap: () {
                _handleTap(FavoritesView());
              },
            ),
            divider,
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search', style: style),
              onTap: () {
                _handleTap(StatePicker(title: "Choose a State"));
              },
            ),
            divider,
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Preferences', style: style),
              onTap: () {
                print('*PREFERENCES*');
              },
            ),
            divider,
          ],
        ),
      ),
    );
  }
}
