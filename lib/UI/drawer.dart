import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/UI/favorites_view.dart';
import 'package:streamwatcher/main.dart';

import 'help.dart';
import 'home_page_view.dart';
import 'state_picker.dart';

class RFDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RFDrawerState();
  var _key = GlobalKey<ScaffoldState>();
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
    double factor = .23;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .5,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Image(
                    image: AssetImage('images/drawerImg.png'),
                    width: size.width * factor,
                    height: size.height * factor,
                    fit: BoxFit.contain),
              ),
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
              leading: Icon(Icons.help),
              title: Text('Help', style: style),
              onTap: () {
                _handleTap(HelpView());
              },
            ),
            divider,

// TODO: revive this button in version 2
//            ListTile(
//              leading: Icon(Icons.settings),
//              title: Text('Preferences', style: style),
//              onTap: () {
//                print('*PREFERENCES*');
//              },
//            ),
//            divider,
          ],
        ),
      ),
    );
  }
}
