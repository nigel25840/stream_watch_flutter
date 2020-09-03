import 'package:progress_dialog/progress_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:streamwatcher/UI/drawer.dart';
import 'package:streamwatcher/UI/gauge_selector_card.dart';
import 'package:streamwatcher/Util/Storage.dart';
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

  GaugeSelector(this.stateAbbreviation) {
    _data = DataProvider().stateGauges(stateAbbreviation);
  }
  _GaugeSelector createState() => _GaugeSelector();
}

class _GaugeSelector extends State<GaugeSelector>
    with SingleTickerProviderStateMixin {
  List<String> faves;
  Map<String, dynamic> _stateGuageList = Map<String, dynamic>();
  PageController _pageController;
  List<GaugeModel> gaugeModels;
  ProgressDialog prog;

  _GaugeSelector();

  @override
  initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future _getGaugesForState() async {
    // prog = ProgressDialog(context);
    // prog.style(
    //     message: "Downloading ${kAllStates[widget.stateAbbreviation]} gauge definitions",
    //     messageTextStyle: TextStyle(fontSize: 14, color: Colors.white),
    //     backgroundColor: Colors.indigo);
    // prog.show();
    if (_stateGuageList.containsKey(widget.stateAbbreviation)) {
      return _stateGuageList[widget.stateAbbreviation];
    }
    List<GaugeModel> gaugeModels =
        await DataProvider().stateGauges(widget.stateAbbreviation);
    _stateGuageList[widget.stateAbbreviation] = gaugeModels;

    return gaugeModels;
  }

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

  ScrollablePositionedList _listView(
      AsyncSnapshot snapshot, BuildContext context) {
    var list = ScrollablePositionedList.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        GaugeModel gauge = snapshot.data[index];
        return GaugeSelectorCard(gauge);
      },
      itemPositionsListener: listener,
      itemScrollController: scroller,
    );

    if (list != null) {
      //scroller.jumpTo(index: 1); // error here
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: Text(kAllStates[widget.stateAbbreviation]),
      ),
      body: FutureBuilder(
        future: _getGaugesForState(),
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
