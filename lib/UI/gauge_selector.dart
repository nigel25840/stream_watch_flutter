import 'package:progress_dialog/progress_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:streamwatcher/UI/rl_appbar.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/UI/gauge_selector_card.dart';
import 'package:streamwatcher/Util/Storage.dart';
import 'package:streamwatcher/model/gauge_model.dart';
import 'package:streamwatcher/viewModel/gauge_selector_viewmodel.dart';
import '../Util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dataServices/data_provider.dart';

class GaugeSelector extends StatefulWidget {
  final String stateAbbreviation;
  Future<List<GaugeReferenceModel>> _data;

  GaugeSelector(this.stateAbbreviation);

  _GaugeSelector createState() => _GaugeSelector();
}

class _GaugeSelector extends State<GaugeSelector> with SingleTickerProviderStateMixin {
  GaugeSelectorViewModel viewModel = GaugeSelectorViewModel();
  List<String> faves;
  Map<String, dynamic> _stateGuageList = Map<String, dynamic>();
  List<GaugeReferenceModel> gaugeModels = [];
  List<GaugeReference> gaugeRefModels;
  ProgressDialog prog;

  _GaugeSelector();

  Future<void> closeDialog() async {
    if (prog != null) {
      await prog.hide();
    }
  }

  _getFavorites() async {
    faves = await Storage.getList(kFavoritesKey);
  }

  var listener = ItemPositionsListener.create();
  var scroller = ItemScrollController();

  ScrollablePositionedList _listView(AsyncSnapshot snapshot, BuildContext context) {
    var list = ScrollablePositionedList.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        GaugeReferenceModel gauge = snapshot.data[index];
        return GaugeSelectorCard(gauge);
      },
      itemPositionsListener: listener,
      itemScrollController: scroller,
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _getFavorites();

    return Scaffold(
      appBar: RLAppBar(titleText: Text(kAllStates[widget.stateAbbreviation])),
      body: FutureBuilder(
        future: viewModel.poplulateVM(state: widget.stateAbbreviation),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _listView(snapshot, context);
          } else {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Loading gauges for'),
                    SizedBox(height: 8,),
                    Text('${kAllStates[widget.stateAbbreviation]}', style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            );
          }
        },
      ),
      endDrawer: RFDrawer(),
    );
  }
}
