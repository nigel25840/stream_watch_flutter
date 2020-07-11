import 'dart:convert';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamwatcher/chart/gauge_detail.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import '../chart/gauge_detail.dart';
import '../Util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dataServices/data_provider.dart';

class GaugeSelector extends StatefulWidget {
  final String stateAbbreviation;
  Future<List<GaugeModel>> _data;
  GaugeSelector({this.stateAbbreviation}) {
    _data = DataProvider().stateGauges(stateAbbreviation);
  }
  _GaugeSelector createState() => _GaugeSelector();
}

class _GaugeSelector extends State<GaugeSelector> {

  List<String> faves;

  Future<List<GaugeModel>> _getStateList(String stateKey) async {
    List<GaugeModel> gaugeModels = await DataProvider().stateGauges(widget.stateAbbreviation);
    return gaugeModels;
  }

  _getFavorites() async {
    faves = await Storage.getList(kFavoritesKey);
  }

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
    _getFavorites();
    return Scaffold(
      appBar: AppBar(
        title: Text(kAllStates[widget.stateAbbreviation]),
      ),
      body: FutureBuilder(
//        future: DataProvider().stateGauges(widget.stateAbbreviation),
        future: _getStateList(widget.stateAbbreviation),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data[index].gaugeName),
                  subtitle: Text(snapshot.data[index].gaugeId),
                  trailing: IconButton(icon: Icon(faves.contains(snapshot.data[index].gaugeId) ? Icons.star : Icons.star_border), onPressed: () {
                    print("row: ${snapshot.data[index].gaugeName} - ${snapshot.data[index].gaugeId}");
                    Storage.putFavorite(kFavoritesKey, snapshot.data[index].gaugeId);
                  },),
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
      endDrawer: RFDrawer(),
    );
  }
}
