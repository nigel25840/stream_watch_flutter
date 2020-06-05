import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/constants.dart';
import 'dart:core';

class StatePicker extends StatefulWidget {
  final String title;
  StatePicker({this.title});
  _StatePicker createState() => _StatePicker();
}

class _StatePicker extends State<StatePicker> {
  final entries = ['Aimee', 'Kelly', 'Elizabeth'];
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
                print(key);
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
    );
  }
}
