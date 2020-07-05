
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("Header"),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('Favorites'),
            onTap: () {
              print('*FAVORITES*');
            },
          ),
          ListTile(
            title: Text('Search'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return StatePicker(title: "Choose a State");
              }));
            },
          ),
          ListTile(
            title: Text('Preferences'),
            onTap: () {
              print('*PREFERENCES*');
            },
          ),
        ],
      ),
    );
  }
}
