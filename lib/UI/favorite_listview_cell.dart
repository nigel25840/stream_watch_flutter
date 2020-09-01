import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/model/favorite_model.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

class FavoriteCell extends StatefulWidget {
  final String gaugeId;
  final UniqueKey key;

  _FavoriteCell createState() => _FavoriteCell(gaugeId);
  FavoriteCell({this.gaugeId, this.key});
}

class _FavoriteCell extends State<FavoriteCell> {
  final String gaugeId;
  FavoritesViewModel vm;

  _FavoriteCell(this.gaugeId);

  Future<FavoriteModel> _getModel(String itemId) async {
    return await vm.getFavoriteItem(gaugeId, true);
  }

  @override
  void initState() {
    vm = Provider.of<FavoritesViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getModel(widget.gaugeId),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          // snapshot will be the model returned by the async task
          // model will be used to populate cell
        },
    );
  }
}
