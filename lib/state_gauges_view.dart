
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamwatcher/constants.dart';

import 'gauge_selector.dart';

class StateGaugesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateGaugesViewState();
}

class _StateGaugesViewState extends State<StateGaugesView> {
  final states = kAllStates;

  @override
  Widget build(BuildContext context) {
    final stateKeys = states.keys;
    return Scaffold(
      body: ListView.builder(
        itemCount: stateKeys.length,
        itemBuilder: (BuildContext context, int index){
          String key = states.keys.elementAt(index);
          var state = states[key];
          return ListTile(
            title: new Text("$state"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GaugeSelector(stateAbbreviation: key);
              }));
            },
          );
        }
      )
    );
  }
}