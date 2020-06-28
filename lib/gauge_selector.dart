import 'dart:convert';

import 'package:streamwatcher/chart/gauge_detail.dart';
import 'package:streamwatcher/gauge_model.dart';

import 'chart/gauge_detail.dart';
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dataServices/data_provider.dart';

class GaugeSelector extends StatefulWidget {
  final String stateAbbreviation;
  Future<List<GaugeModel>> _data;
  GaugeSelector({this.stateAbbreviation}) {
    _data = DataProvider().stateGauges(stateAbbreviation);
  }
  _GaugeSelector createState() => _GaugeSelector();
}

class _GaugeSelector extends State<GaugeSelector> {
  ListView showStateGauges() {
    ListView lv = ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: [
              new ListTile(
                title: new Text("$index"),
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAllStates[widget.stateAbbreviation]),
      ),
      body: FutureBuilder(
        future: DataProvider().stateGauges(widget.stateAbbreviation),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data[index].gaugeName),
                  subtitle: Text(snapshot.data[index].gaugeId),
                  onTap: () {
                    print(snapshot.data[index].gaugeId);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return GaugeDetail(
                          gaugeId: snapshot.data[index].gaugeId,
                          gaugeName: snapshot.data[index].gaugeName);
                    }));
                  },
                );
              },
            );
          } else {
            return Align(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
