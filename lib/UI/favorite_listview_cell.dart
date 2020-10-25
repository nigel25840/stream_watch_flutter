import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/gauge_detail_chart.dart';
import 'package:streamwatcher/Util/constants.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/model/favorite_model.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

class FavoriteCell extends StatefulWidget {
  final String gaugeId;
  final UniqueKey key;
  final bool isDismissable;
  bool reload = false;

  _FavoriteCell createState() => _FavoriteCell(gaugeId);
  FavoriteCell({this.gaugeId, this.key, this.isDismissable, this.reload});
}

class _FavoriteCell extends State<FavoriteCell> {
  final String gaugeId;
  FavoritesViewModel vm;
  FavoriteModel model;
  TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  TextStyle subStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);

  _FavoriteCell(this.gaugeId);

  Future<FavoriteModel> _getModel(String itemId, [bool refresh = false]) async {
    if(vm.favoriteModels[itemId] == null || !vm.isPopulated(vm.favoriteModels[itemId])) {
      try {
        return await vm.getFavoriteItem(gaugeId, true).timeout(const Duration(seconds: 30));
      } on TimeoutException catch (_) {
        FavoriteModel timeoutModel = FavoriteModel(itemId, 'Gauge timed out!');
        timeoutModel.currentStage = -1;
        timeoutModel.currentFlow = -1;
        return timeoutModel;
      } on SocketException catch (_) {
        FavoriteModel timeoutModel = FavoriteModel(itemId, 'Gauge temporarily unavailable!');
        timeoutModel.currentStage = -1;
        timeoutModel.currentFlow = -1;
        return timeoutModel;
      } on Exception catch (_) {
        FavoriteModel timeoutModel = FavoriteModel(itemId, 'Error occurred! Check later.');
        timeoutModel.currentStage = -1;
        timeoutModel.currentFlow = -1;
        return timeoutModel;
      }
    } else {
      return vm.favoriteModels[itemId];
    }
  }

  String _formatReading({double value, bool cfs}) {
    // '${model.currentFlow != null ? model.currentFlow.round().toString() + 'cfs' : 'CFS: N/A'}',
    if (value != kReadingErrorValue) {
      if (cfs) {
        return '${value.round().toString()} cfs';
      } else {
        return '${value.toString()} ft';
      }
    }
    return '${cfs ? 'CFS' : 'Ft'}: N/A';
  }

  @override
  void initState() {
    vm = Provider.of<FavoritesViewModel>(context, listen: false);
    super.initState();
  }

  String formatTimeStamp(DateTime date, String format) {
    if (date == null){
      return 'N/A';
    }
    DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<FavoritesViewModel>(
      builder: (context, model, child) => FutureBuilder(
        future: _getModel(widget.gaugeId, widget.reload),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // snapshot will be the model returned by the async task
          // model will be used to populate cell
          if(snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data is FavoriteModel) {
              FavoriteModel model = snapshot.data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Dismissible(
                    direction: widget.isDismissable ? DismissDirection.endToStart : null,
                    key: UniqueKey(),
                    onDismissed: (_) {
                      vm.deleteFavorite(model.favoriteId, false);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('${model.favoriteName} was removed from favorites')));
                    },
                    child: GestureDetector(
                      child: buildCard(context, model),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          // return GaugeDetail(
                          //   gaugeId: model.favoriteId,
                          //   gaugeName: model.favoriteName,
                          // );
                          return GaugeDetailChart(referenceModel: GaugeReferenceModel(gaugeName: model.favoriteName, gaugeId: model.favoriteId));
                        }));
                      },
                    ),
                    background: Container(
                      color: Colors.red,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'Deleting...',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          }
          return Card(
              elevation: 2,
              color: Colors.tealAccent,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        },
      ),
    );
  }

  Card buildCard(BuildContext context, FavoriteModel model) {
    return Card(
              elevation: 2,
              color: Colors.tealAccent,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width * .9,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(model.favoriteName, style: titleStyle, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false,),
                                            Text('Last updated: ${formatTimeStamp(model.lastUpdated, 'MMM dd, yyyy')}')
                                          ],
                                        )
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${model.currentFlow != null ? _formatReading(value: model.currentFlow, cfs: true) : 'CFS:N\A'}',
                                  style: subStyle),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  '${model.currentStage != null ? _formatReading(value: model.currentStage, cfs: false) : 'Ft.: N/A'}',
                                  style: subStyle),
                            ],
                          ),
                        ),

                        // TODO: refactor gauge model and revive trend arrow
                        Icon((model.increasing != null) ? (model.increasing ? Icons.arrow_upward : Icons.arrow_downward) : Icons.remove),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ));
  }
}
