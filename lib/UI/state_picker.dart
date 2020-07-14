import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'dart:core';

import 'package:streamwatcher/UI/gauge_selector.dart';

class StatePicker extends StatefulWidget {
  final String title;
  StatePicker({this.title});
  _StatePicker createState() => _StatePicker();
}

class _StatePicker extends State<StatePicker> {
  final states = kAllStates;

  ListView showStates() {
    var stateKeys = states.keys;

    ListView lv = ListView.separated(
      padding: EdgeInsets.all(10.0),
      itemCount: stateKeys.length,
      itemBuilder: (BuildContext context, int index) {
        String key = states.keys.elementAt(index);
        return new Column(
          children: <Widget>[
            new ListTile(
              title: new Text("${states[key]}"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GaugeSelector(key);
                }));
              },
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );

    return lv;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: showStates().build(context),
      endDrawer: RFDrawer(),
    );
  }
}

class RFBottomNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RFBottomNavigationState();
}


class _RFBottomNavigationState extends State<RFBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
