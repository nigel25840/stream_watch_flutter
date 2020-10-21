import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:streamwatcher/UI/gauge_detail_chart.dart';
import 'package:streamwatcher/chart/gauge_detail.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/favorites_view_model.dart';

class GaugeSelectorCard extends StatefulWidget {
  final GaugeReferenceModel model;
  GaugeSelectorCard(this.model);
  _GaugeSelectorCard createState() => _GaugeSelectorCard();
}

class _GaugeSelectorCard extends State<GaugeSelectorCard> {
  FavoritesViewModel viewModel;
  bool isFavorite = false;

  @override
  void initState() {
    viewModel = Provider.of<FavoritesViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    GaugeReferenceModel _model = widget.model;
    isFavorite = viewModel.favorites.contains(_model.gaugeId);

    return Consumer<FavoritesViewModel>(
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          color: Colors.black.withAlpha(12),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: IconButton(
              icon: Icon(isFavorite ? Icons.star : Icons.star_border),
              onPressed: () {
                setState(() {
                  if(isFavorite) {
                    viewModel.deleteFavorite(_model.gaugeId);
                  } else {
                    viewModel.addFavorite(_model.gaugeId);
                  }
                });
              },
            ),
            title: Text(_model.gaugeName),
            subtitle: Text('USGS ID: ${_model.gaugeId}'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              print(_model.gaugeId);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                // return GaugeDetail(
                //     gaugeId: _model.gaugeId, gaugeName: _model.gaugeName);
                return GaugeDetailChart(referenceModel: _model);
              }));
            },
          ),
        ),
      ),
    );

  }
// TODO: not in use. Card slows scroll performance in long lists.
// Either resolve this issue or remove this class

//class _GaugeSelectorCard extends State<GaugeSelectorCard> {
//  bool isFavorite = false;
//  @override
//  Widget build(BuildContext context) {
//    double screenWidth = MediaQuery.of(context).size.width;
//    GaugeModel model = widget.model;
//
//    return Card(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//      color: Colors.white.withOpacity(0.5),
//      child: Row(
//        children: [
//          IconButton(
//            icon: Icon(Icons.star_border),
//          ),
//          SizedBox(
//              width: screenWidth * .8,
//              child: Text(model.gaugeName,
//                  overflow: TextOverflow.ellipsis,
//                  maxLines: 1,
//                  softWrap: false,
//                  style: TextStyle(
//                    fontWeight: FontWeight.w500,
//                    fontSize: 16.0,
//                  ))),
//          Icon(Icons.arrow_forward_ios),
//        ],
//      ),
//    );
//  }
}
